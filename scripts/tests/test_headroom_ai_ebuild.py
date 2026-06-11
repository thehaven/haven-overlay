
"""
Tests for headroom-ai ebuild quality.
"""

import re
from pathlib import Path

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent
HEADROOM_EBUILDS = sorted(
    (OVERLAY_ROOT / "dev-python" / "headroom-ai").glob("headroom-ai-*.ebuild")
)


def _parse_ebuild(path: Path) -> dict:
    text = path.read_text()
    result = {}
    result["PV"] = re.search(r'headroom-ai-(.+?)\.ebuild', path.name).group(1)
    result["DISTUTILS_USE_PEP517"] = re.search(
        r'DISTUTILS_USE_PEP517\s*=\s*(\w+)', text
    ).group(1)
    m = re.search(r'PYTHON_COMPAT=\s*\(\s*(.+?)\s*\)', text)
    if m:
        raw = m.group(1)
        versions = []
        for part in raw.split():
            bm = re.match(r'python(\d+)_\{(\d+)\.\.(\d+)\}', part)
            if bm:
                major = int(bm.group(1))
                for minor in range(int(bm.group(2)), int(bm.group(3)) + 1):
                    versions.append(f"python{major}_{minor}")
            else:
                versions.append(part)
        result["PYTHON_COMPAT"] = versions
    result["has_pyo3_forward_compat"] = (
        "PYO3_USE_ABI3_FORWARD_COMPATIBILITY" in text
    )
    return result


def test_headroom_ai_pyo3_forward_compat_for_python3_14():
    """If PYTHON_COMPAT includes python3_14 and DISTUTILS_USE_PEP517=maturin,
    the ebuild MUST set PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1."""
    failures = []
    for ep in HEADROOM_EBUILDS:
        info = _parse_ebuild(ep)
        if info.get("DISTUTILS_USE_PEP517") != "maturin":
            continue
        if "python3_14" not in info.get("PYTHON_COMPAT", []):
            continue
        if not info.get("has_pyo3_forward_compat"):
            failures.append(
                f"{ep.name}: maturin + python3_14 requires "
                f"PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1 "
                f"(PyO3 0.22.x max is 3.13)"
            )
    if failures:
        raise AssertionError("\n".join(failures))
