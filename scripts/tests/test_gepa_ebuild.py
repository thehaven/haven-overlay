"""
Tests for gepa ebuild quality — validates ebuild metadata against PyPI.
"""

import json
import re
from pathlib import Path
from urllib.request import urlopen

import pytest

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent
GEPA_EBUILDS = sorted((OVERLAY_ROOT / "dev-python" / "gepa").glob("gepa-*.ebuild"))


def _to_version_tuple(v: str) -> tuple:
    m = re.match(r"(?:python)?(\d+)_?\.?(\d+)", v)
    if not m:
        raise ValueError(f"Cannot parse version: {v}")
    return (int(m.group(1)), int(m.group(2)))


def _parse_ebuild(ebuild_path: Path) -> dict:
    text = ebuild_path.read_text()
    result = {}
    m = re.match(r"gepa-(.+?)\.ebuild", ebuild_path.name)
    if m:
        result["PV"] = m.group(1)
    m = re.search(r"PYTHON_COMPAT=\s*\(\s*(.+?)\s*\)", text)
    if m:
        raw = m.group(1)
        versions = []
        for part in raw.split():
            brace_m = re.match(r"python(\d+)_\{(\d+)\.\.(\d+)\}", part)
            if brace_m:
                major = int(brace_m.group(1))
                start = int(brace_m.group(2))
                end = int(brace_m.group(3))
                for minor in range(start, end + 1):
                    versions.append(f"python{major}_{minor}")
            else:
                versions.append(part)
        result["PYTHON_COMPAT"] = versions
    m = re.search(r"IUSE=\"(.+?)\"", text)
    if m:
        result["IUSE"] = m.group(1).split()
    return result


def _pypi_info(package: str, version: str) -> dict | None:
    try:
        url = f"https://pypi.org/pypi/{package}/{version}/json"
        with urlopen(url, timeout=15) as resp:
            return json.loads(resp.read())
    except Exception:
        return None


def _parse_requires_python(spec: str) -> tuple:
    min_vt = None
    max_vt = None
    for m in re.finditer(r"(>=?|<=?|!=?=?)\s*(\d+\.\d+)", spec):
        op, ver_str = m.group(1), m.group(2)
        vt = _to_version_tuple(ver_str)
        if op in (">=", ">", "=="):
            if min_vt is None or vt > min_vt:
                min_vt = vt
        if op in ("<=", "<"):
            if max_vt is None or vt < max_vt:
                max_vt = vt
    return min_vt, max_vt


def _version_in_range(py_ver, min_v, max_v):
    if min_v and py_ver < min_v:
        return False
    if max_v and py_ver >= max_v:
        return False
    return True


def _ebuild_ids():
    return [p.name for p in GEPA_EBUILDS]


@pytest.mark.parametrize("ebuild_path", GEPA_EBUILDS, ids=_ebuild_ids())
def test_gepa_version_exists_on_pypi(ebuild_path: Path) -> None:
    parsed = _parse_ebuild(ebuild_path)
    pv = parsed.get("PV")
    assert pv, f"Could not parse PV from {ebuild_path.name}"
    info = _pypi_info("gepa", pv)
    assert info is not None, (
        f"gepa=={pv} not found on PyPI (may be yanked or never existed)"
    )


@pytest.mark.parametrize("ebuild_path", GEPA_EBUILDS, ids=_ebuild_ids())
def test_gepa_python_compat_matches_pypi(ebuild_path: Path) -> None:
    parsed = _parse_ebuild(ebuild_path)
    pv = parsed.get("PV")
    compat = parsed.get("PYTHON_COMPAT", [])
    assert pv, f"Could not parse PV from {ebuild_path.name}"
    assert compat, f"No PYTHON_COMPAT found in {ebuild_path.name}"
    info = _pypi_info("gepa", pv)
    assert info is not None, f"gepa=={pv} not on PyPI (prerequisite)"
    requires_python = info.get("info", {}).get("requires_python") or ""
    if not requires_python:
        pytest.skip(f"gepa=={pv} has no requires_python constraint")
    min_vt, max_vt = _parse_requires_python(requires_python)
    assert min_vt or max_vt, f"Cannot parse requires_python: {requires_python}"
    failures = []
    for c in compat:
        py_vt = _to_version_tuple(c)
        if not _version_in_range(py_vt, min_vt, max_vt):
            failures.append(c)
    assert not failures, (
        f"gepa=={pv} requires Python {requires_python}, "
        f"but PYTHON_COMPAT includes unsupported: {failures}. "
        f"Fix: remove from PYTHON_COMPAT or use --ignore-requires-python."
    )


@pytest.mark.parametrize("ebuild_path", GEPA_EBUILDS, ids=_ebuild_ids())
def test_gepa_use_flags_map_to_upstream_extras(ebuild_path: Path) -> None:
    parsed = _parse_ebuild(ebuild_path)
    pv = parsed.get("PV")
    assert pv, f"Could not parse PV from {ebuild_path.name}"
    info = _pypi_info("gepa", pv)
    assert info is not None, f"gepa=={pv} not on PyPI (prerequisite)"
    available_extras = set(info.get("info", {}).get("provides_extra", []))
    for flag in parsed.get("IUSE", []):
        if flag.startswith("+"):
            flag = flag[1:]
        assert flag in available_extras, (
            f"USE flag '{flag}' has no matching upstream extra for gepa=={pv} "
            f"(upstream provides: {sorted(available_extras)}). "
            f"Either add the extra upstream or drop/rename the flag."
        )
