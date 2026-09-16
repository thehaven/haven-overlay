"""Regression guard: fastmcp-importing ebuilds must pin dev-python/mcp below 2.x.

mcp 2.x removed ``mcp.server.fastmcp`` (the 2.2.0 ``fastmcp.py`` is a
16-line shim that raises ModuleNotFoundError). The overlay ships mcp
1.27.0-1.28.1 and 2.0.0-2.2.0 but no 1.29.x, so an unbounded
``dev-python/mcp`` dep resolves to 2.2.0 on a fresh install and breaks
at import. Verified 2026-09-16 from installed site-packages and
distfiles: semgrep, ebuild-updater, x402, mcp-pagerduty (and previously
skillspector, stele) all import ``mcp.server.fastmcp``.

The failure mode this guards against: ebuild-updater's bump stage copies
the LATEST ebuild as the new-version template, so a stale unpinned dep
propagates to every future bump until someone notices (same class as the
PEP517 backend drift).
"""

import re
from pathlib import Path

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent

# Package dirs whose source imports mcp.server.fastmcp (verified from
# installed site-packages / distfiles, 2026-09-16). mcp-server-time is
# allowed <3 because it ships an mcp2-compat patch in files/; every other
# package here must pin <2.
FASTMCP_PACKAGES = {
    "app-admin/stele",
    "app-vuln/semgrep",
    "app-vuln/skillspector",
    "dev-python/mcp-server-time",
    "dev-python/x402",
    "dev-util/ebuild-updater",
    "dev-util/mcp-pagerduty",
}

# Upper-bound atoms that keep the dep on a 1.x (or patched) mcp.
SAFE_UPPER_BOUND = re.compile(r"<dev-python/mcp-[23]")


def test_fastmcp_importers_pin_mcp_below_2():
    offenders = []
    for pkg in sorted(FASTMCP_PACKAGES):
        pkg_dir = OVERLAY_ROOT / pkg
        ebuilds = sorted(pkg_dir.glob("*.ebuild"))
        assert ebuilds, f"no ebuilds found for {pkg} (dir moved?)"
        for eb in ebuilds:
            text = eb.read_text(errors="ignore")
            if "dev-python/mcp" not in text:
                # No mcp dep declared -> nothing can resolve to mcp 2.x.
                # (e.g. mcp-pagerduty-0.1.0, a stale live snapshot)
                continue
            if not SAFE_UPPER_BOUND.search(text):
                offenders.append(
                    f"{pkg}/{eb.name}: mcp dep not pinned below 2.x "
                    "(mcp 2.x removed mcp.server.fastmcp)"
                )
    assert not offenders, (
        "fastmcp-importing ebuilds with unpinned mcp dep (breaks at import "
        f"once mcp 2.x is installed):\n" + "\n".join(offenders)
    )