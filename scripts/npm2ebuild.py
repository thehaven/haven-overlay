#!/usr/bin/env python3
"""
npm2ebuild.py — Professional Node.js to Gentoo Ebuild generator.
Strictly source-based, zero-trust for 'npm install'.
"""

import os
import sys
import json
import requests
import argparse
from pathlib import Path
from datetime import datetime
from typing import Set

class NPMResolver:
    REGISTRY = "https://registry.npmjs.org"

    def __init__(self, overlay_path: Path, root_category="dev-nodejs"):
        self.overlay_path = overlay_path
        self.root_category = root_category
        self.processed: Set[str] = set()

    def normalize_name(self, name: str) -> str:
        """Normalize npm package name to Gentoo PN."""
        return name.replace("@", "").replace("/", "-").replace(".", "-")

    def normalize_version(self, version: str) -> str:
        """Normalize npm version to Gentoo version."""
        # Convert 1.2.3-rc.4 to 1.2.3_rc4
        v = version.replace("-", "_").replace(".rc", "_rc").replace(".beta", "_beta").replace(".alpha", "_alpha")
        # Remove dots after the first three components if they exist (e.g. 1.2.3.4 -> 1.2.3_p4)
        parts = v.split(".")
        if len(parts) > 3:
            v = ".".join(parts[:3]) + "_p" + "".join(parts[3:])
        return v

    def fetch_metadata(self, name: str, version: str = "latest"):
        """Fetch package metadata from npm registry."""
        encoded_name = name.replace("/", "%2f")
        url = f"{self.REGISTRY}/{encoded_name}/{version}"
        print(f"[*] Fetching {url}...")
        resp = requests.get(url)
        resp.raise_for_status()
        return resp.json()

    def safe_bash_string(self, s: str) -> str:
        """Escape characters that would break a bash double-quoted string."""
        return s.replace('\\', '\\\\').replace('"', '\\"').replace('`', '\\`').replace('$', '\\$')

    def generate_ebuild(self, metadata: dict, is_root=False):
        """Generate a Gentoo ebuild from npm metadata."""
        name = metadata["name"]
        pn = self.normalize_name(name)
        pv = self.normalize_version(metadata["version"])
        
        desc = self.safe_bash_string(metadata.get("description", "Node.js module"))
        homepage = metadata.get("homepage", f"https://www.npmjs.com/package/{name}")
        
        license_str = metadata.get("license", "unknown")
        if isinstance(license_str, dict): license_str = license_str.get("type", "unknown")

        license_map = {
            "MIT": "MIT", "Apache-2.0": "Apache-2.0", "ISC": "ISC",
            "BSD-2-Clause": "BSD-2", "BSD-3-Clause": "BSD",
            "AGPL-3.0": "AGPL-3", "GPL-3.0": "GPL-3"
        }
        gentoo_license = license_map.get(license_str, "unknown")

        deps = []
        for d_name, d_ver in metadata.get("dependencies", {}).items():
            deps.append(f"dev-nodejs/{self.normalize_name(d_name)}")

        ebuild_content = f'''# Copyright 1999-{datetime.now().year} Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="{name}"
inherit npm

DESCRIPTION="{desc}"
HOMEPAGE="{homepage}"

LICENSE="{gentoo_license}"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
{chr(10).join(['\t' + d for d in sorted(list(set(deps)))])}
"
BDEPEND="${{RDEPEND}}"
'''
        cat = self.root_category if is_root else "dev-nodejs"
        pkg_dir = self.overlay_path / cat / pn
        pkg_dir.mkdir(parents=True, exist_ok=True)
        
        ebuild_path = pkg_dir / f"{pn}-{pv}.ebuild"
        print(f"[+] Writing ebuild: {ebuild_path}")
        with open(ebuild_path, "w") as f:
            f.write(ebuild_content)
            
        self.generate_metadata(pkg_dir, name, pn, desc)
        return ebuild_path

    def generate_metadata(self, pkg_dir: Path, name: str, pn: str, desc: str):
        metadata_content = f'''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE pkgmetadata SYSTEM "https://www.gentoo.org/dtd/metadata.dtd">
<pkgmetadata>
\t<maintainer type="person">
\t\t<email>haven@thehavennet.org.uk</email>
\t\t<name>Simon Alman</name>
\t</maintainer>
\t<upstream>
\t\t<remote-id type="npm">{name}</remote-id>
\t</upstream>
</pkgmetadata>
'''
        with open(pkg_dir / "metadata.xml", "w") as f:
            f.write(metadata_content)

    def resolve_recursive(self, name: str, version: str = "latest"):
        if name in self.processed:
            return
        self.processed.add(name)
        
        if not hasattr(self, "root_package"):
            self.root_package = name
            
        try:
            metadata = self.fetch_metadata(name, version)
            self.generate_ebuild(metadata, is_root=(name == self.root_package))
            
            deps = metadata.get("dependencies", {})
            for d_name, d_ver in deps.items():
                self.resolve_recursive(d_name)
        except Exception as e:
            print(f"[!] Failed to resolve {name}: {e}")

def main():
    parser = argparse.ArgumentParser(description="npm to Gentoo ebuild generator")
    parser.add_argument("package", help="npm package name")
    parser.add_argument("--version", default="latest", help="Package version")
    parser.add_argument("--overlay", default="/var/db/repos/haven-overlay", help="Overlay path")
    parser.add_argument("--category", default="dev-nodejs", help="Category for root package")
    
    args = parser.parse_args()
    
    resolver = NPMResolver(Path(args.overlay), root_category=args.category)
    resolver.resolve_recursive(args.package, args.version)

if __name__ == "__main__":
    main()
