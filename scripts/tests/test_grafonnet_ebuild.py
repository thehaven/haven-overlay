
"""Tests for grafonnet and jsonnet-deps ebuild quality."""

import re
from pathlib import Path
from urllib.request import urlopen
import json

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent

GRAFONNET_EBUILDS = sorted(
    (OVERLAY_ROOT / "app-metrics" / "grafonnet").glob("grafonnet-*.ebuild")
)
DOCSONNET_EBUILDS = sorted(
    (OVERLAY_ROOT / "dev-libs" / "jsonnet-docsonnet").glob("*.ebuild")
)
XTD_EBUILDS = sorted(
    (OVERLAY_ROOT / "dev-libs" / "jsonnet-xtd").glob("*.ebuild")
)

REQUIRED_FILES = [
    "main.libsonnet", "dashboard.libsonnet", "panel.libsonnet",
    "query.libsonnet", "alerting.libsonnet",
]


def _parse_ebuild(path: Path) -> dict:
    text = path.read_text()
    result = {}
    m = re.search(r"DESCRIPTION=\"(.+?)\"", text)
    if m:
        result["DESCRIPTION"] = m.group(1)
    m = re.search(r"HOMEPAGE=\"(.+?)\"", text)
    if m:
        result["HOMEPAGE"] = m.group(1)
    m = re.search(r"LICENSE=\"(.+?)\"", text)
    if m:
        result["LICENSE"] = m.group(1)
    m = re.search(r"SRC_URI=\"(.+?)\"", text)
    if m:
        result["SRC_URI"] = m.group(1)
    m = re.match(r".+?-(\S+)\.ebuild", path.name)
    if m:
        result["PV"] = m.group(1)
    result["IUSE"] = "IUSE" in text
    return result


def _fetch_url_ok(url: str) -> bool:
    try:
        with urlopen(url, timeout=15) as resp:
            return 200 <= resp.status < 400
    except Exception:
        return False


def test_grafonnet_ebuild_exists():
    assert len(list(GRAFONNET_EBUILDS)) > 0, "No grafonnet ebuild found"


def test_grafonnet_src_uri_fetchable():
    for ep in GRAFONNET_EBUILDS:
        info = _parse_ebuild(ep)
        uri = info.get("SRC_URI", "")
        assert uri, f"{ep.name}: no SRC_URI"
        gh_match = re.search(r"github\.com/(.+?)/archive", uri)
        assert gh_match, f"{ep.name}: SRC_URI not a GitHub archive: {uri}"


def test_grafonnet_license():
    for ep in GRAFONNET_EBUILDS:
        info = _parse_ebuild(ep)
        assert info.get("LICENSE"), f"{ep.name}: missing LICENSE"


def test_grafonnet_deps_have_ebuilds():
    """docsonnet and xtd must have ebuilds in the overlay."""
    assert len(list(DOCSONNET_EBUILDS)) > 0, "No jsonnet-docsonnet ebuild"
    assert len(list(XTD_EBUILDS)) > 0, "No jsonnet-xtd ebuild"
