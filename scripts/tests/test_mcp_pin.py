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
propagates to every future bump until someone notices (same class as
the PEP517 backend drift).

Three guards live in this file:

1. ``test_fastmcp_importers_pin_mcp_below_2`` — the original guard. It is
   text-based and per-ebuild across EVERY version of a package directory.
2. ``test_current_version_mcp_pins_are_present`` — a resolve-time bound on
   ``dev-python/mcp`` asserted on the CURRENT (newest stable) version only.
   Adding a package to ``FASTMCP_PACKAGES`` would demand the bound in every
   retired version too and rewrite history, so packages that only need the
   newest version fixed are listed in ``CURRENT_VERSION_MCP_PINS`` instead.
3. ``test_fastmcp_consumers_declare_a_resolve_time_bound`` — every fastmcp
   consumer's current version must declare an upper bound below fastmcp 4.x.
   The ``>=dev-python/fastmcp-4.0.0`` line in ``profiles/package.mask`` is
   install-time only, so without a declaration in the ebuild itself that
   mask line is the single point of failure holding the whole fleet below
   fastmcp 4.x. Consumers that predate this guard are recorded in
   ``UNGUARDED_FASTMCP_CONSUMERS`` and are REPORTED, not failed — the guard
   fails only when the unguarded set GROWS.
"""

import re
from functools import cmp_to_key
from pathlib import Path

try:  # portage is present on every Gentoo host; keep a fallback for portability
    from portage.versions import vercmp as _vercmp
except ImportError:  # pragma: no cover

    def _vkey(v: str):
        base, _, rev = v.partition("-r")
        nums = tuple(int(c) if c.isdigit() else 0 for c in base.split("."))
        return (nums, int(rev) if rev.isdigit() else 0)

    def _vercmp(a: str, b: str) -> int:
        ka, kb = _vkey(a), _vkey(b)
        return (ka > kb) - (ka < kb)


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

# Packages whose CURRENT (newest stable) version must carry a resolve-time
# upper bound on dev-python/mcp. Kept separate from FASTMCP_PACKAGES above
# so that fixing the newest in-tree version does not rewrite the retired
# ones (the overlay's "fix the newest, not every version" rule).
CURRENT_VERSION_MCP_PINS = {
    "app-admin/mcp-mesh": re.compile(r"<dev-python/mcp-2"),
}

# fastmcp consumers whose CURRENT version still declares no upper bound.
# This is a RECORDED BASELINE: the guard fails when the set grows, not
# because these entries are present. Each is protected today only by the
# install-time mask in profiles/package.mask.
UNGUARDED_FASTMCP_CONSUMERS = {
    "app-misc/mem0-mcp",
    "dev-python/clr-librenms-mcp",
    "dev-util/mcp-server-analyzer",
    "dev-util/mcp-server-aws",
    "dev-util/mcp-server-gemini-deepsearch",
    "dev-util/mcp-server-linkedin",
    "dev-util/mcp-server-opentofu",
    "dev-util/mcp-server-pass",
}

# fastmcp 4.x hard-requires mcp 2.x, and mcp 2.x removed
# mcp.server.fastmcp — so an upper bound below 4.x is the safe floor.
FASTMCP_MAJOR_4 = "4.0.0"

# <dev-python/fastmcp-<version> upper-bound atoms.
FASTMCPUPPER = re.compile(r"<dev-python/fastmcp-([0-9][0-9.]*(?:-[a-z0-9]+)*)")


def _pv(ebuild: Path, pkg_dir: Path) -> str:
    """PV extracted from an ebuild filename."""
    return ebuild.name[len(pkg_dir.name) + 1 : -len(".ebuild")]


def _current_version_ebuild(pkg_dir: Path) -> Path:
    """The newest STABLE ebuild in a package directory.

    9999 is the live-git snapshot ebuild. It is opt-in only (it is not in a
    host's default install set) so it is excluded from "current version".
    """
    ebuilds = [eb for eb in pkg_dir.glob("*.ebuild") if _pv(eb, pkg_dir) != "9999"]
    assert ebuilds, f"no stable ebuilds found in {pkg_dir}"
    return max(
        ebuilds,
        key=cmp_to_key(lambda a, b: _vercmp(_pv(a, pkg_dir), _pv(b, pkg_dir))),
    )


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


def test_current_version_mcp_pins_are_present():
    offenders = []
    for pkg, bound in sorted(CURRENT_VERSION_MCP_PINS.items()):
        pkg_dir = OVERLAY_ROOT / pkg
        assert pkg_dir.is_dir(), f"package dir missing: {pkg}"
        eb = _current_version_ebuild(pkg_dir)
        text = eb.read_text(errors="ignore")
        if "dev-python/mcp" not in text:
            offenders.append(
                f"{pkg}: current version {eb.name} declares no dev-python/mcp dep"
            )
            continue
        if not bound.search(text):
            offenders.append(
                f"{pkg}/{eb.name}: current version does not declare "
                f"{bound.pattern} (mcp 2.x removed mcp.server.fastmcp)"
            )
    assert not offenders, (
        "current-version mcp pin missing (the newest stable version must "
        "carry the resolve-time bound):\n" + "\n".join(offenders)
    )


def _fastmcp_consumer_dirs():
    """Every package dir with an ebuild that declares dev-python/fastmcp."""
    found = {}
    for eb in sorted(OVERLAY_ROOT.rglob("*.ebuild")):
        if "dev-python/fastmcp" not in eb.read_text(errors="ignore"):
            continue
        found.setdefault(eb.parent, []).append(eb)
    return found


def test_fastmcp_consumers_declare_a_resolve_time_bound():
    unguarded = set()
    for pkg_dir in _fastmcp_consumer_dirs():
        eb = _current_version_ebuild(pkg_dir)
        text = eb.read_text(errors="ignore")
        bounds = FASTMCPUPPER.findall(text)
        if not bounds or any(_vercmp(b, FASTMCP_MAJOR_4) >= 0 for b in bounds):
            unguarded.add(str(pkg_dir.relative_to(OVERLAY_ROOT)))
    new = unguarded - UNGUARDED_FASTMCP_CONSUMERS
    assert not new, (
        "fastmcp consumers whose current version declares no resolve-time "
        "upper bound below fastmcp 4.x (add them to "
        "UNGUARDED_FASTMCP_CONSUMERS only after fixing them):\n"
        + "\n".join(sorted(new))
    )
    now_guarded = UNGUARDED_FASTMCP_CONSUMERS - unguarded
    print(
        f"fastmcp resolve-time guard: {len(unguarded)} consumer(s) still "
        f"unguarded (recorded baseline {len(UNGUARDED_FASTMCP_CONSUMERS)}), "
        f"{len(now_guarded)} baseline entries now guarded"
    )
