#!/usr/bin/env python3
# Copyright 2026 Simon Alman
# SPDX-License-Identifier: GPL-2.0-only
"""Generate source-based npm ebuilds for haven-overlay.

Usage:
    npm2ebuild.py --list <file>           # process package list, one per line
    npm2ebuild.py --package <name>@<ver>  # single package
    npm2ebuild.py --all                   # read seerr deps from /tmp/seerr-deps.txt

Each ebuild follows the haven-overlay convention:
- EAPI=8
- inherit npm
- KEYWORDS="~amd64"
- RDEPEND/BDEPEND empty by default (Node module resolution at /usr/lib/node_modules)
- metadata.xml with maintainer + remote-id type=npm

Native modules (bcrypt, sharp, sqlite3, node-gyp) get QA overrides via --native flag.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import urllib.request
from pathlib import Path
from typing import Any

OVERLAY = Path("/var/db/repos/haven-overlay")
DEV_NODEJS = OVERLAY / "dev-nodejs"
MAINTAINER_EMAIL = "user@example.com"
MAINTAINER_NAME = "Simon Alman"
USER_AGENT = "haven-overlay-npm2ebuild/1.0"

# Packages needing native build support (prebuilds in tarball, need QA relax)
NATIVE_PACKAGES = {
    "bcrypt",
    "sharp",
    "sqlite3",
    "node-gyp",
    "@swc/core",
    "cypress",
}

# QA relaxations for native modules shipping prebuilds
NATIVE_BINARY_QA = "QA_PREBUILT='*.node'\nRESTRICT='strip'"


def fetch_npm_metadata(name: str, version: str) -> dict[str, Any]:
    """Fetch package metadata from npm registry."""
    url = f"https://registry.npmjs.org/{name}/{version}"
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode("utf-8"))


def fetch_latest(name: str) -> str:
    """Fetch latest version from npm registry."""
    url = f"https://registry.npmjs.org/{name}/latest"
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode("utf-8"))["version"]


def normalize_license(license_field: Any) -> str:
    """Normalize npm license field to Gentoo LICENSE format."""
    if not license_field:
        return "MIT"
    if isinstance(license_field, str):
        return license_field.strip()
    if isinstance(license_field, dict):
        return license_field.get("type", "MIT").strip()
    if isinstance(license_field, list):
        return " ".join(
            item if isinstance(item, str) else item.get("type", "MIT")
            for item in license_field
        )
    return "MIT"


def description_safe(desc: str | None, max_len: int = 80) -> str:
    """Clean description: strip newlines, cap length, escape quotes."""
    if not desc:
        return "Node.js package"
    desc = desc.split("\n")[0].strip()
    desc = desc.replace('"', "'")
    if len(desc) > max_len:
        desc = desc[: max_len - 3] + "..."
    return desc


def gen_ebuild(name: str, version: str) -> tuple[Path, str, str]:
    """Generate ebuild content. Returns (path, ebuild_text, desc)."""
    meta = fetch_npm_metadata(name, version)

    license_field = normalize_license(meta.get("license"))
    desc = description_safe(meta.get("description"))
    homepage = meta.get("homepage", f"https://www.npmjs.com/package/{name}")
    bin_field = meta.get("bin")

    lines = [
        "# Copyright 1999-2026 Gentoo Authors",
        "# Distributed under the terms of the GNU General Public License v2",
        "",
        "EAPI=8",
        "",
    ]

    if name.startswith("@"):
        lines.append(f'NPM_MODULE="{name}"')
    lines.append("inherit npm")
    lines.append("")

    lines.extend(
        [
            f'DESCRIPTION="{desc}"',
            f'HOMEPAGE="{homepage}"',
            "",
            f'LICENSE="{license_field}"',
            'SLOT="0"',
            'KEYWORDS="~amd64"',
            "",
        ]
    )

    if name in NATIVE_PACKAGES:
        lines.extend([NATIVE_BINARY_QA, ""])

    lines.extend(
        [
            'RDEPEND=""',
            'BDEPEND="${RDEPEND}"',
            "",
        ]
    )

    if bin_field:
        bin_entries: list[tuple[str, str]] = []
        if isinstance(bin_field, str):
            bin_entries.append((f"bin/{bin_field}", bin_field))
        elif isinstance(bin_field, dict):
            for bin_name, bin_path in bin_field.items():
                bin_entries.append((bin_path, bin_name))
        if bin_entries:
            lines.append("src_install() {")
            lines.append("\tnpm_src_install")
            for bin_path, bin_name in bin_entries:
                lines.append(f'\tnpm_install_bin "{bin_path}" {bin_name}')
            lines.append("}")
            lines.append("")

    # Path layout: dev-nodejs/<name>/<pn>-<pv>.ebuild
    # For scoped packages the name contains '/', so we must build the path
    # in two steps to avoid Path() splitting on the slash inside the name.
    pkg_dir = DEV_NODEJS / name
    pkg_basename = name.rsplit("/", 1)[-1]
    ebuild_path = Path(str(pkg_dir) + f"/{pkg_basename}-{version}.ebuild")
    return (
        ebuild_path,
        "\n".join(lines),
        desc,
    )


def gen_metadata_xml(name: str) -> str:
    """Generate metadata.xml."""
    return f"""<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pkgmetadata SYSTEM "https://www.gentoo.org/dtd/metadata.dtd">
<pkgmetadata>
\t<maintainer type="person">
\t\t<email>{MAINTAINER_EMAIL}</email>
\t\t<name>{MAINTAINER_NAME}</name>
\t</maintainer>
\t<upstream>
\t\t<remote-id type="npm">{name}</remote-id>
\t</upstream>
</pkgmetadata>
"""


def write_package(name: str, version: str) -> Path:
    """Generate ebuild + metadata.xml. Returns path to ebuild."""
    ebuild_path, ebuild_text, _ = gen_ebuild(name, version)
    pkg_dir = ebuild_path.parent
    pkg_dir.mkdir(parents=True, exist_ok=True)
    ebuild_path.write_text(ebuild_text)
    (pkg_dir / "metadata.xml").write_text(gen_metadata_xml(name))
    return ebuild_path


def parse_spec(spec: str) -> tuple[str, str]:
    """Parse 'name@version' or just 'name' (latest)."""
    if "@" in spec:
        name, version = spec.rsplit("@", 1)
        return name.strip("/"), version.strip()
    return spec.strip("/"), fetch_latest(spec.strip("/"))


def process_spec(spec: str) -> Path:
    name, version = parse_spec(spec)
    return write_package(name, version)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--package", "-p", action="append", help="name@version or name")
    parser.add_argument("--list", "-l", type=Path, help="File of specs, one per line")
    parser.add_argument("--all", action="store_true", help="Use /tmp/seerr-deps.txt")
    args = parser.parse_args()

    specs: list[str] = []
    if args.package:
        specs.extend(args.package)
    if args.list:
        for line in args.list.read_text().splitlines():
            line = line.strip()
            if line and not line.startswith("#"):
                specs.append(line)
    if args.all:
        deps_file = Path("/tmp/seerr-deps.txt")
        if deps_file.exists():
            for line in deps_file.read_text().splitlines():
                line = line.strip()
                if line and not line.startswith("#"):
                    specs.append(line)
        else:
            print(f"ERROR: {deps_file} not found", file=sys.stderr)
            return 1

    if not specs:
        parser.print_help()
        return 1

    ok = fail = 0
    for spec in specs:
        try:
            ebuild = process_spec(spec)
            print(f"OK   {ebuild}")
            ok += 1
        except Exception as exc:
            print(f"FAIL {spec}: {exc}", file=sys.stderr)
            fail += 1
    print(f"\n{ok} ok, {fail} failed", file=sys.stderr)
    return 0 if fail == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
