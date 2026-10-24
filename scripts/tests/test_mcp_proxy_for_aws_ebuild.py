"""
Tests for the mcp-proxy-for-aws ebuild — validates ebuild metadata against PyPI
and asserts the packaging invariants the successor's migration depends on.

The invariants asserted here are the ones that would otherwise only be caught
by a broken client at runtime:

  * the ebuild never emits a `uvx` runtime resolver (the overlay's Native Path
    Alignment standard: instructions point at the packaged /usr/bin path);
  * the ebuild never prints the retired daemon's command;
  * the fastmcp range is expressed as a resolve-time bound, not left to the
    install-time `>=dev-python/fastmcp-4.0.0` mask;
  * python_test() asserts the console-script TARGET, not the distribution name.
"""

import json
import re
from pathlib import Path
from urllib.request import urlopen

import pytest

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent
EBUILD_DIR = OVERLAY_ROOT / "dev-util" / "mcp-proxy-for-aws"
EBUILDS = sorted(EBUILD_DIR.glob("mcp-proxy-for-aws-*.ebuild"))

RETIRED_COMMAND = "awslabs.aws-api-mcp-server"
NATIVE_PATH = "/usr/bin/mcp-proxy-for-aws"
CONSOLE_SCRIPT_TARGET = "mcp_proxy_for_aws.server"


def _ebuild_ids() -> list[str]:
    return [p.name for p in EBUILDS]


def _pypi_info(package: str, version: str) -> dict | None:
    try:
        url = f"https://pypi.org/pypi/{package}/{version}/json"
        with urlopen(url, timeout=15) as resp:
            return json.loads(resp.read())
    except Exception:
        return None


def _parse_ebuild(path: Path) -> dict:
    text = path.read_text()
    result = {"text": text}
    m = re.match(r"mcp-proxy-for-aws-(.+?)\.ebuild", path.name)
    if m:
        result["PV"] = m.group(1)
    m = re.search(r'PYPI_PN="([^"]+)"', text)
    if m:
        result["PYPI_PN"] = m.group(1)
    m = re.search(r'DISTUTILS_USE_PEP517=(\S+)', text)
    if m:
        result["PEP517"] = m.group(1)
    m = re.search(r"PYTHON_COMPAT=\(\s*(.+?)\s*\)", text)
    if m:
        result["PYTHON_COMPAT_RAW"] = m.group(1)
    return result


def _expand_python_compat(raw: str) -> set[str]:
    """Expand `python3_{12..14}` brace ranges into the concrete tags."""
    out: set[str] = set()
    for part in raw.split():
        m = re.match(r"python(\d+)_\{(\d+)\.\.(\d+)\}", part)
        if m:
            major, start, end = int(m.group(1)), int(m.group(2)), int(m.group(3))
            for minor in range(start, end + 1):
                out.add(f"python{major}_{minor}")
        else:
            out.add(part)
    return out


@pytest.mark.parametrize("ebuild_path", EBUILDS, ids=_ebuild_ids())
def test_version_exists_on_pypi(ebuild_path: Path) -> None:
    parsed = _parse_ebuild(ebuild_path)
    pv = parsed.get("PV")
    assert pv, f"Could not parse PV from {ebuild_path.name}"
    info = _pypi_info(parsed["PYPI_PN"], pv)
    assert info is not None, (
        f"{parsed['PYPI_PN']}=={pv} not found on PyPI "
        f"(may be yanked or never existed)"
    )


@pytest.mark.parametrize("ebuild_path", EBUILDS, ids=_ebuild_ids())
def test_python_compat_is_inside_upstream_requires_python(ebuild_path: Path) -> None:
    parsed = _parse_ebuild(ebuild_path)
    pv = parsed.get("PV")
    info = _pypi_info(parsed["PYPI_PN"], pv)
    assert info is not None, "prerequisite: version on PyPI"
    requires_python = info.get("info", {}).get("requires_python") or ""
    if not requires_python:
        pytest.skip(f"{pv} declares no requires_python")
    lo = re.search(r">=\s*(\d+\.\d+)", requires_python)
    hi = re.search(r"<\s*(\d+\.\d+)", requires_python)
    compat = _expand_python_compat(parsed["PYTHON_COMPAT_RAW"])
    for minor in range(12, 15):
        assert f"python3_{minor}" in compat, (
            f"python3_{minor} missing from PYTHON_COMPAT"
        )
    if lo:
        assert "python3_12" in compat, "python3_12 below upstream minimum"
    if hi:
        # upstream is <3.15 -> python3_14 is the newest supported
        assert "python3_15" not in compat, "python3_15 is above upstream maximum"


@pytest.mark.parametrize("ebuild_path", EBUILDS, ids=_ebuild_ids())
def test_emits_native_path_not_a_runtime_resolver(ebuild_path: Path) -> None:
    """Native Path Alignment: the packaged /usr/bin path, never npx/uvx."""
    text = _parse_ebuild(ebuild_path)["text"]
    assert NATIVE_PATH in text, (
        f"the native path {NATIVE_PATH} must appear in the post-install message"
    )
    for forbidden in ("uvx", "npx", "mcp-proxy-for-aws@latest"):
        assert forbidden not in text, (
            f"the ebuild must not reference {forbidden!r} — the packaged atom "
            f"IS the pin; a runtime resolver re-introduces unpinned transitive "
            f"dependency drift"
        )


@pytest.mark.parametrize("ebuild_path", EBUILDS, ids=_ebuild_ids())
def test_never_prints_the_retired_daemon(ebuild_path: Path) -> None:
    text = _parse_ebuild(ebuild_path)["text"]
    assert RETIRED_COMMAND not in text, (
        f"the retired command {RETIRED_COMMAND!r} must not appear in the "
        f"post-install message"
    )


@pytest.mark.parametrize("ebuild_path", EBUILDS, ids=_ebuild_ids())
def test_fastmcp_upper_bound_is_declared(ebuild_path: Path) -> None:
    """The `>=dev-python/fastmcp-4.0.0` mask only bites at install time.

    The overlay's ebuild must carry the resolve-time bound so a fresh install
    cannot silently select fastmcp 4.x.
    """
    text = _parse_ebuild(ebuild_path)["text"]
    assert "<dev-python/fastmcp-3.5" in text, (
        "the ebuild must declare an upper bound on dev-python/fastmcp; "
        "upstream requires fastmcp>=3.2,<3.5"
    )


@pytest.mark.parametrize("ebuild_path", EBUILDS, ids=_ebuild_ids())
def test_python_test_asserts_the_console_script_target(ebuild_path: Path) -> None:
    text = _parse_ebuild(ebuild_path)["text"]
    assert CONSOLE_SCRIPT_TARGET in text, (
        f"python_test() must import {CONSOLE_SCRIPT_TARGET} — the console-script "
        f"target — and not merely the distribution name"
    )
    assert NATIVE_PATH in text, "python_test() must assert the console script exists"


@pytest.mark.parametrize("ebuild_path", EBUILDS, ids=_ebuild_ids())
def test_no_inherited_build_backend_rewrite(ebuild_path: Path) -> None:
    """Upstream 1.7.0 declares hatchling.build natively.

    The retired ebuild's `uv_build` rewrite exists because THAT distribution
    declared uv_build; copying it here would be cargo-culting. The check is
    on the REWRITE, not on the word — the ebuild is expected to name the
    backend in its explanatory comment.
    """
    text = _parse_ebuild(ebuild_path)["text"]
    body = "\n".join(
        line for line in text.splitlines() if not line.lstrip().startswith("#")
    )
    assert "uv_build" not in body, (
        "the ebuild body must not carry a uv_build rewrite — verify the sdist's "
        "declared build-backend before adding any fix-up"
    )
    assert "src_prepare()" not in body, (
        "the ebuild must not override src_prepare() to rewrite the backend"
    )


@pytest.mark.parametrize("ebuild_path", EBUILDS, ids=_ebuild_ids())
def test_metadata_xml_present(ebuild_path: Path) -> None:
    assert (EBUILD_DIR / "metadata.xml").is_file(), (
        "dev-util/mcp-proxy-for-aws/metadata.xml is missing"
    )
