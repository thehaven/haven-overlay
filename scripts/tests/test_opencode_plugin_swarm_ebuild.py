"""
Tests for dev-util/opencode-plugin-swarm ebuild quality and governance.
"""

from pathlib import Path
import re
import xml.etree.ElementTree as ET
import pytest

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent
PKG_DIR = OVERLAY_ROOT / "dev-util" / "opencode-plugin-swarm"
EBUILDS = sorted(PKG_DIR.glob("opencode-plugin-swarm-*.ebuild"))
METADATA_XML = PKG_DIR / "metadata.xml"
FILES_DIR = PKG_DIR / "files"


def test_ebuilds_exist():
    assert len(EBUILDS) > 0, "No ebuilds found for dev-util/opencode-plugin-swarm"


@pytest.mark.parametrize("ebuild_path", EBUILDS)
def test_description_length(ebuild_path: Path):
    """Gentoo QA: DESCRIPTION must be <= 80 characters."""
    text = ebuild_path.read_text(encoding="utf-8")
    m = re.search(r'DESCRIPTION="([^"]+)"', text)
    assert m, f"DESCRIPTION not found in {ebuild_path.name}"
    desc = m.group(1)
    assert len(desc) <= 80, (
        f"{ebuild_path.name}: DESCRIPTION length is {len(desc)} chars (> 80 chars max): {desc!r}"
    )


@pytest.mark.parametrize("ebuild_path", EBUILDS)
def test_sandbox_use_flag_and_rdepend(ebuild_path: Path):
    """The ebuild must declare IUSE="+sandbox" and RDEPEND on bubblewrap under sandbox?."""
    text = ebuild_path.read_text(encoding="utf-8")
    
    # Check IUSE
    m_iuse = re.search(r'IUSE="([^"]+)"', text)
    assert m_iuse, f"IUSE declaration missing in {ebuild_path.name}"
    iuse_flags = m_iuse.group(1).split()
    assert "+sandbox" in iuse_flags or "sandbox" in iuse_flags, (
        f"{ebuild_path.name}: IUSE must declare '+sandbox'"
    )
    
    # Check RDEPEND
    assert "sandbox? ( sys-apps/bubblewrap )" in text or "sys-apps/bubblewrap" in text, (
        f"{ebuild_path.name}: RDEPEND must include bubblewrap (sandbox? ( sys-apps/bubblewrap ))"
    )
    assert "net-libs/nodejs" in text, (
        f"{ebuild_path.name}: RDEPEND must require nodejs runtime"
    )


def test_metadata_documents_sandbox_use_flag():
    """metadata.xml must describe the 'sandbox' local USE flag."""
    assert METADATA_XML.exists(), "metadata.xml missing"
    tree = ET.parse(METADATA_XML)
    root = tree.getroot()
    flags = [flag.get("name") for flag in root.findall(".//flag")]
    assert "sandbox" in flags, "metadata.xml missing <flag name='sandbox'> description"


@pytest.mark.parametrize("ebuild_path", EBUILDS)
def test_referenced_patches_and_shims_exist(ebuild_path: Path):
    """Every patch listed in PATCHES and shim in src_install must exist in files/."""
    text = ebuild_path.read_text(encoding="utf-8")
    pv = re.search(r'opencode-plugin-swarm-(.+?)\.ebuild', ebuild_path.name).group(1)
    p = f"opencode-plugin-swarm-{pv}"
    pn = "opencode-plugin-swarm"
    
    # Check PATCHES
    patches_match = re.search(r'PATCHES=\s*\(\s*(.*?)\s*\)', text, re.DOTALL)
    if patches_match:
        raw_patches = patches_match.group(1).split()
        for raw in raw_patches:
            resolved = raw.strip('"\'')
            resolved = resolved.replace("${FILESDIR}", str(FILES_DIR))
            resolved = resolved.replace("${P}", p)
            resolved = resolved.replace("${PN}", pn)
            resolved = resolved.replace("${PV}", pv)
            patch_file = Path(resolved)
            assert patch_file.exists(), (
                f"{ebuild_path.name}: Referenced patch does not exist: {patch_file.name}"
            )
            assert patch_file.stat().st_size > 0, (
                f"{ebuild_path.name}: Patch is empty: {patch_file.name}"
            )

    # Check newins shims
    newins_matches = re.findall(r'newins\s+"([^"]+)"', text)
    for raw in newins_matches:
        resolved = raw.replace("${FILESDIR}", str(FILES_DIR))
        resolved = resolved.replace("${P}", p)
        resolved = resolved.replace("${PN}", pn)
        resolved = resolved.replace("${PV}", pv)
        shim_file = Path(resolved)
        assert shim_file.exists(), (
            f"{ebuild_path.name}: Referenced shim file does not exist: {shim_file.name}"
        )
