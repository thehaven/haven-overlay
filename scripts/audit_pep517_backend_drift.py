#!/usr/bin/env python3
"""Whole-overlay audit: DISTUTILS_USE_PEP517 vs upstream pyproject.toml.

For every ebuild under ``dev-python/`` that sets ``DISTUTILS_USE_PEP517``,
find the matching tarball in ``/usr/portage-distfiles/``, extract
``pyproject.toml``, read ``build-backend``, and compare against the ebuild's
PEP517 value via the canonical skill mapping.

Detected the 2026-09-02 wave: 47 ebuilds across 11 dev-python packages in
haven-overlay had ``DISTUTILS_USE_PEP517`` values that no longer matched
upstream ``pyproject.toml`` ``build-backend``. See
``references/pep517-backend-drift.md`` in the gentoo-ebuild skill for
context; the openspec change ``add-pep517-backend-drift-scan`` proposes to
wire this audit into ``ebuild-updater cleanup scan`` as a new
``wrong-pep517-backend`` category.

Usage:
    audit_pep517_backend_drift.py [--overlay PATH] [--json] [--quiet]

Exit code: 0 if no mismatches found; 1 otherwise.
"""
import argparse
import json
import os
import re
import sys
import tarfile
import zipfile
from pathlib import Path

# Skill mapping: upstream build-backend -> canonical DISTUTILS_USE_PEP517.
BACKEND_MAP = {
    "setuptools.build_meta": "setuptools",
    "hatchling.build": "hatchling",
    "flit_core.buildapi": "flit",
    "poetry.core.masonry.api": "poetry",
    "pdm.backend": "pdm-backend",
    "maturin": "maturin",
    "mesonpy": "meson-python",
    "uv_build": "uv-build",
}


def extract_pyproject(tarball_path):
    """Return (pyproject_text, member_name) or (None, None)."""
    if tarball_path.suffix == ".zip":
        try:
            with zipfile.ZipFile(tarball_path) as zf:
                for n in zf.namelist():
                    if n.endswith("/pyproject.toml") or n == "pyproject.toml":
                        return zf.read(n).decode("utf-8", errors="replace"), n
        except (zipfile.BadZipFile, OSError):
            pass
        return None, None
    try:
        with tarfile.open(tarball_path, "r:*") as tf:
            candidates = []
            for m in tf.getmembers():
                name = m.name
                if not (name.endswith("/pyproject.toml") or name == "pyproject.toml"):
                    continue
                parts = name.replace("./", "").split("/")
                if len(parts) <= 2:
                    candidates.append(m)
            if not candidates:
                return None, None
            candidates.sort(key=lambda m: len(m.name))
            f = tf.extractfile(candidates[0])
            if f is None:
                return None, None
            return f.read().decode("utf-8", errors="replace"), candidates[0].name
    except (tarfile.TarError, OSError):
        return None, None


def parse_backend(pyproject_text):
    if not pyproject_text:
        return None
    m = re.search(r'build-backend\s*=\s*["\']([^"\']+)["\']', pyproject_text)
    return m.group(1) if m else None


def ebuild_pep517(ebuild_text):
    m = re.search(r'DISTUTILS_USE_PEP517\s*=\s*"?([A-Za-z0-9_-]+)"?', ebuild_text)
    return m.group(1) if m else None


def find_distfiles(distfiles_dir, pkg, version):
    pat = re.compile(rf'^{re.escape(pkg)}-{re.escape(version)}.*\.(tar\.(gz|xz|bz2|zst)|zip)$')
    out = []
    if not distfiles_dir.exists():
        return out
    for f in distfiles_dir.iterdir():
        if pat.match(f.name):
            out.append(f)
    suffix_order = {".tar.gz": 0, ".tar.xz": 1, ".tar.zst": 2, ".tar.bz2": 3, ".zip": 4}
    out.sort(key=lambda f: suffix_order.get("".join(f.suffixes[-2:]) if f.suffix == ".gz" else f.suffix, 99))
    return out


def parse_ebuild_path(ebuild_path):
    name = ebuild_path.name
    if not name.endswith(".ebuild"):
        return None, None
    base = name[:-7]
    m = re.match(r'^(.+)-(\d.*)$', base)
    if not m:
        return None, None
    return m.group(1), m.group(2)


def audit(overlay, distfiles_dir):
    mismatches = []
    skipped = []
    ebuilds_scanned = 0
    pyproject_found = 0
    for ebuild in sorted(overlay.glob("dev-python/*/*.ebuild")):
        pkg, ver = parse_ebuild_path(ebuild)
        if not pkg:
            continue
        text = ebuild.read_text(errors="replace")
        pep517 = ebuild_pep517(text)
        if pep517 is None:
            continue
        ebuilds_scanned += 1
        candidates = find_distfiles(distfiles_dir, pkg, ver)
        if not candidates:
            skipped.append({"ebuild": str(ebuild), "reason": "no distfile in distfiles dir"})
            continue
        pyproject_text, member = extract_pyproject(candidates[0])
        if not pyproject_text:
            skipped.append({"ebuild": str(ebuild), "reason": f"{candidates[0].name}: no pyproject.toml"})
            continue
        pyproject_found += 1
        backend = parse_backend(pyproject_text)
        if backend is None:
            skipped.append({"ebuild": str(ebuild), "reason": f"{candidates[0].name}: no build-backend"})
            continue
        expected = BACKEND_MAP.get(backend)
        if expected is None:
            skipped.append({"ebuild": str(ebuild), "reason": f"{candidates[0].name}: unknown backend {backend!r}"})
            continue
        if expected != pep517:
            mismatches.append({
                "ebuild": str(ebuild),
                "tarball": candidates[0].name,
                "member": member,
                "upstream_backend": backend,
                "ebuild_pep517": pep517,
                "should_be": expected,
            })
    return {
        "ebuilds_scanned": ebuilds_scanned,
        "pyproject_found": pyproject_found,
        "mismatches": mismatches,
        "skipped": skipped,
    }


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--overlay", default="/var/db/repos/haven-overlay",
                   help="Path to the overlay (default: /var/db/repos/haven-overlay)")
    p.add_argument("--distfiles", default="/usr/portage-distfiles",
                   help="Path to the distfiles cache (default: /usr/portage-distfiles)")
    p.add_argument("--json", action="store_true",
                   help="Emit machine-readable JSON (consumed by ebuild-updater cleanup scan)")
    p.add_argument("--quiet", action="store_true",
                   help="Print only the summary line and mismatches (used by CI)")
    args = p.parse_args()

    overlay = Path(args.overlay)
    distfiles = Path(args.distfiles)
    if not overlay.is_dir():
        print(f"overlay not found: {overlay}", file=sys.stderr)
        return 2

    result = audit(overlay, distfiles)
    has_mismatches = bool(result["mismatches"])

    if args.json:
        print(json.dumps(result, indent=2, sort_keys=True))
    else:
        if not args.quiet:
            print(f"ebuilds scanned:       {result['ebuilds_scanned']}")
            print(f"pyproject.toml found:  {result['pyproject_found']}")
            print(f"skipped (no data):     {len(result['skipped'])}")
            print()
        print(f"MISMATCHES:            {len(result['mismatches'])}")
        if result["mismatches"] and not args.quiet:
            print()
            print("=== DISTUTILS_USE_PEP517 MISMATCHES ===")
            for m in result["mismatches"]:
                print(f"\n  {m['ebuild']}")
                print(f"    tarball: {m['tarball']} (member: {m['member']})")
                print(f"    upstream backend: {m['upstream_backend']}  -> should set DISTUTILS_USE_PEP517={m['should_be']}")
                print(f"    ebuild currently sets:             DISTUTILS_USE_PEP517={m['ebuild_pep517']}")
        if result["skipped"] and not args.quiet:
            print()
            print(f"=== Skipped ({len(result['skipped'])} entries - no pyproject.toml, unknown backend, or no distfile) ===")
            for s in result["skipped"][:20]:
                print(f"  {s['ebuild']}  -- {s['reason']}")
            if len(result["skipped"]) > 20:
                print(f"  ... and {len(result['skipped']) - 20} more")

    return 1 if has_mismatches else 0


if __name__ == "__main__":
    sys.exit(main())
