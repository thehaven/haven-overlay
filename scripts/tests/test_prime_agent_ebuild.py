"""Tests for the prime-agent ebuild and its dependency chain.

Guards the overlay against regressions that already happened once:
- a duplicate prime-agent ebuild in a second category (dev-util/, removed
  2026-08-08) that diverged and collided on file paths;
- a stale version pinned against the latest upstream release;
- a Node floor that drifts from package.json engines;
- a LICENSE that loses the bundled-dependency coverage.
"""

import json
import re
from pathlib import Path
from urllib.request import urlopen

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent

UPSTREAM = "PrimeIntellect-ai/prime-agent"


def _prime_agent_dirs() -> list[Path]:
    """Every directory named prime-agent in the overlay (any category)."""
    return sorted(OVERLAY_ROOT.glob("*/prime-agent"))


def _prime_agent_ebuilds() -> list[Path]:
    return sorted(
        e for d in _prime_agent_dirs() for e in d.glob("*.ebuild")
    )


def _read_ebuild(path: Path) -> str:
    return path.read_text()


def _parse_var(text: str, name: str) -> str:
    m = re.search(rf'{name}="(.+?)"', text, re.S)
    return m.group(1) if m else ""


def _latest_upstream_tag() -> str:
    with urlopen(
        f"https://api.github.com/repos/{UPSTREAM}/releases/latest", timeout=15
    ) as resp:
        return json.load(resp)["tag_name"]


def test_single_prime_agent_ebuild():
    """The duplicate tripwire: exactly one ebuild, in app-misc only."""
    ebuilds = _prime_agent_ebuilds()
    assert len(ebuilds) == 1, (
        f"expected exactly one prime-agent ebuild, found {len(ebuilds)}: "
        f"{[str(e) for e in ebuilds]}"
    )
    assert ebuilds[0].parent.parent.name == "app-misc", (
        f"prime-agent must live in app-misc, found {ebuilds[0]}"
    )


def test_no_duplicate_upstream_reference():
    """No other ebuild may claim the same upstream (runtime shim excepted)."""
    offenders = []
    for ebuild in OVERLAY_ROOT.glob("*/*/*.ebuild"):
        text = ebuild.read_text(errors="ignore")
        if UPSTREAM in text and ebuild.parent.parent.name not in (
            "app-misc", "dev-python",
        ):
            offenders.append(str(ebuild))
    assert not offenders, f"duplicate upstream reference: {offenders}"


def test_version_matches_upstream():
    for ebuild in _prime_agent_ebuilds():
        pv = ebuild.name[: -len(".ebuild")].rsplit("-", 1)[1]
        tag = _latest_upstream_tag()
        assert tag == f"v{pv}", (
            f"{ebuild.name}: ebuild PV {pv} != latest upstream tag {tag}"
        )


def test_node_floor_matches_engines():
    """RDEPEND must satisfy package.json engines (node >=22.8.0)."""
    for ebuild in _prime_agent_ebuilds():
        text = _read_ebuild(ebuild)
        assert re.search(
            r"net-libs/nodejs-22\.8\.0", text
        ), f"{ebuild.name}: RDEPEND node floor missing (engines: >=22.8.0)"


def test_license_covers_bundled_deps():
    """LICENSE must list dependency licenses, not just upstream's MIT."""
    for ebuild in _prime_agent_ebuilds():
        license_var = _parse_var(_read_ebuild(ebuild), "LICENSE")
        assert "MIT" in license_var
        extra = set(license_var.split()) - {"MIT"}
        assert len(extra) >= 3, (
            f"{ebuild.name}: LICENSE only lists {license_var}; bundled npm "
            "deps (Apache-2.0, ISC, BSD, MPL-2.0, ...) must be covered"
        )


def test_bin_symlink_installed():
    for ebuild in _prime_agent_ebuilds():
        text = _read_ebuild(ebuild)
        assert re.search(r"dosym .*?/usr/bin/prime-agent", text), (
            f"{ebuild.name}: missing /usr/bin/prime-agent dosym"
        )
        assert "fperms +x" in text, (
            f"{ebuild.name}: missing fperms +x on the bin target"
        )


def test_runtime_dependency_packaged():
    """dev-python/prime-agent-runtime (kernel shim) must exist."""
    runtime = sorted(
        (OVERLAY_ROOT / "dev-python" / "prime-agent-runtime").glob("*.ebuild")
    )
    assert runtime, "dev-python/prime-agent-runtime ebuild missing"
    for ebuild in _prime_agent_ebuilds():
        assert "prime-agent-runtime" in _read_ebuild(ebuild), (
            f"{ebuild.name}: missing RDEPEND on dev-python/prime-agent-runtime"
        )
