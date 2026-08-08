"""
Tests for the hermes-agent-self-evolution ebuild — validates the ebuild
against the upstream GitHub repository (the project has no PyPI release
and no tags, so SRC_URI pins a main-branch commit).
"""

import json
import re
from pathlib import Path
from urllib.request import urlopen

import pytest

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent
EBUILD_DIR = OVERLAY_ROOT / "dev-python" / "hermes-agent-self-evolution"
EBUILDS = sorted(EBUILD_DIR.glob("hermes-agent-self-evolution-*.ebuild"))

REPO = "NousResearch/hermes-agent-self-evolution"
RAW_BASE = f"https://raw.githubusercontent.com/{REPO}"


def _github_json(url: str):
    try:
        with urlopen(url, timeout=15) as resp:
            return json.loads(resp.read())
    except Exception:
        return None


def _raw_file(commit: str, path: str) -> str | None:
    try:
        with urlopen(f"{RAW_BASE}/{commit}/{path}", timeout=15) as resp:
            return resp.read().decode()
    except Exception:
        return None


def _parse_ebuild(path: Path) -> dict:
    text = path.read_text()
    result = {}
    m = re.match(r"hermes-agent-self-evolution-(.+?)\.ebuild", path.name)
    if m:
        result["PV"] = m.group(1)
    m = re.search(r"HERMES_EVO_COMMIT=\"([0-9a-f]+)\"", text)
    if m:
        result["commit"] = m.group(1)
    m = re.search(r"SRC_URI=\"([^\"]+)\"", text)
    if m:
        result["SRC_URI"] = m.group(1)
    m = re.search(r"RDEPEND=\"(.*?)\"", text, re.S)
    if m:
        result["RDEPEND"] = m.group(1)
    m = re.search(r"PYTHON_COMPAT=\s*\(\s*(.+?)\s*\)", text)
    if m:
        result["PYTHON_COMPAT"] = m.group(1).split()
    m = re.search(r"^DESCRIPTION=\"(.+?)\"", text, re.M)
    if m:
        result["DESCRIPTION"] = m.group(1)
    m = re.search(r"LICENSE=\"(.+?)\"", text)
    if m:
        result["LICENSE"] = m.group(1)
    return result


def _compat_to_python(compat: list) -> tuple:
    """Expand python3_{12..14} style entries into (major, minor) tuples."""
    versions = []
    for part in compat:
        brace_m = re.match(r"python(\d+)_\{(\d+)\.\.(\d+)\}", part)
        if brace_m:
            major = int(brace_m.group(1))
            for minor in range(int(brace_m.group(2)), int(brace_m.group(3)) + 1):
                versions.append((major, minor))
        else:
            m = re.match(r"python(\d+)_(\d+)", part)
            if m:
                versions.append((int(m.group(1)), int(m.group(2))))
    return tuple(versions)


@pytest.fixture(scope="module")
def ebuild() -> dict:
    assert EBUILDS, "no hermes-agent-self-evolution ebuild found"
    return _parse_ebuild(EBUILDS[-1])


def test_single_ebuild(ebuild):
    assert len(EBUILDS) == 1, "expected exactly one ebuild"


def test_pinned_commit_is_current_main(ebuild):
    """The pinned commit must still be the tip of main (no tags exist,
    so the ebuild is the canonical source of truth for the release)."""
    commits = _github_json(f"https://api.github.com/repos/{REPO}/commits?per_page=1")
    if commits is None:
        pytest.skip("GitHub API unavailable")
    assert commits[0]["sha"] == ebuild["commit"], (
        "main has moved past the pinned commit; bump HERMES_EVO_COMMIT"
    )


def test_no_upstream_tags(ebuild):
    """SRC_URI is commit-based because upstream has never tagged a release."""
    tags = _github_json(f"https://api.github.com/repos/{REPO}/tags?per_page=5")
    if tags is None:
        pytest.skip("GitHub API unavailable")
    assert tags == [], "upstream now has tags; migrate SRC_URI to a tag archive"


def test_version_matches_pyproject(ebuild):
    pyproject = _raw_file(ebuild["commit"], "pyproject.toml")
    if pyproject is None:
        pytest.skip("pyproject.toml unreachable")
    m = re.search(r'^version\s*=\s*"([^"]+)"', pyproject, re.M)
    assert m, "version not found in pyproject.toml"
    assert m.group(1) == ebuild["PV"], (
        f"pyproject version {m.group(1)} != ebuild PV {ebuild['PV']}"
    )


def test_src_uri_uses_pinned_commit(ebuild):
    assert "${HERMES_EVO_COMMIT}" in ebuild["SRC_URI"], (
        "SRC_URI must reference the pinned HERMES_EVO_COMMIT variable"
    )
    assert len(ebuild["commit"]) == 40, "HERMES_EVO_COMMIT must be a full sha"
    assert ebuild["SRC_URI"].endswith(".tar.gz"), "SRC_URI must be a .tar.gz archive"


def test_rdepend_covers_all_core_dependencies(ebuild):
    """Every core dependency in pyproject.toml must appear in RDEPEND."""
    pyproject = _raw_file(ebuild["commit"], "pyproject.toml")
    if pyproject is None:
        pytest.skip("pyproject.toml unreachable")
    section = re.search(r"^dependencies\s*=\s*\[(.*?)\]", pyproject, re.S | re.M)
    assert section, "dependencies not found in pyproject.toml"
    declared = re.findall(r'"([a-z0-9_-]+)', section.group(1))
    for dep in declared:
        # pyyaml -> dev-python/pyyaml, openai -> dev-python/openai
        atom = f"dev-python/{dep}"
        assert atom in ebuild["RDEPEND"], f"{atom} missing from RDEPEND"


def test_python_compat_within_requires_python(ebuild):
    pyproject = _raw_file(ebuild["commit"], "pyproject.toml")
    if pyproject is None:
        pytest.skip("pyproject.toml unreachable")
    m = re.search(r'^requires-python\s*=\s*"([^"]+)"', pyproject, re.M)
    assert m, "requires-python not found in pyproject.toml"
    req = m.group(1)
    min_m = re.search(r">=(\d+)\.(\d+)", req)
    max_m = re.search(r"<(\d+)\.(\d+)", req)
    for major, minor in _compat_to_python(ebuild["PYTHON_COMPAT"]):
        if min_m:
            assert (major, minor) >= (int(min_m.group(1)), int(min_m.group(2))), (
                f"python{major}_{minor} below requires-python {req}"
            )
        if max_m:
            assert (major, minor) < (int(max_m.group(1)), int(max_m.group(2))), (
                f"python{major}_{minor} above requires-python {req}"
            )


def test_metadata_fields(ebuild):
    assert ebuild["DESCRIPTION"], "DESCRIPTION empty"
    assert len(ebuild["DESCRIPTION"]) <= 80, "DESCRIPTION too long"
    assert ebuild["LICENSE"] == "MIT"
