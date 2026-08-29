"""Regression test: every SRC_URI distfile URL in the overlay must be fetchable.

Catches dead mirror/vendor tarballs (e.g. ``opencode-models-*.json`` on the
cleaned gentoo-mirror cache) that silently break ``ebuild manifest`` and
therefore ebuild-updater bumps. Verified 2026-08-29: the gentoo-mirror only
mirrors the three official Gentoo distfile sources; custom artefacts 404.

Two assertions:
1. ``test_no_new_broken_urls`` — no SRC_URI URL may fail to fetch unless it is
   listed in KNOWN_BROKEN (regression guard against new breakage).
2. ``test_change_targets_fixed`` — URLs this change is fixing (CHANGE_TARGETS)
   must fetch OK. RED while the fixes are pending; GREEN once tasks 1-5 land.
"""

import re
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from urllib.request import Request, urlopen

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent

_USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) haven-overlay-src-uri-test/1.0"

# Hosts that are private/unreachable from the dev host and cannot be verified.
SKIP_HOSTS = {"artifactory.delivery.haven.pw"}

# URLs this change (fix-ebuild-bump-failures) is fixing. Must be GREEN at the
# end of the change. Keyed by task group.
CHANGE_TARGETS = {
    # Task 1: dev-util/opencode dead mirror dependency
    "https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/opencode-models-1.16.2.json",
    # Task 2: mirror-tarball packages converted to inherit bun/npm
    "https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/audiobookshelf-client-node_modules-2.35.1.tar.xz",
    "https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/audiobookshelf-server-node_modules-2.35.1.tar.xz",
    "https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/minions-node_modules-0.1.15.tar.xz",
    "https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/oh-my-openagent-node_modules-4.4.0.tar.xz",
    "https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/oh-my-opencode-slim-node_modules-2.0.0-beta.13.tar.xz",
    "https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/opencode-plugin-otel-node_modules-1.0.0.tar.xz",
    "https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/tokscale-node_modules-2.1.3.tar.xz",
    # Task 5: vendor-tarball migrations
    "https://dev.gentoo.org/~haven/nats-server/nats-server-2.10.22-vendor.tar.xz",
    "https://dev.gentoo.org/~haven/mattermost-server/mattermost-server-11.6.1-vendor.tar.xz",
    "https://github.com/twpayne/chezmoi/releases/download/v2.70.0/chezmoi-2.70.0-deps.tar.xz",
}

# Known-broken URLs NOT fixed by this change (documented follow-ups). Failures
# here are tolerated; fixing them removes them from the failure set harmlessly.
KNOWN_BROKEN = CHANGE_TARGETS | {
    # dev.gentoo.org/~haven vendor tarballs (follow-up: migrate to source)
    "https://dev.gentoo.org/~haven/cedar-go/cedar-go-1.8.0-vendor.tar.xz",
    "https://dev.gentoo.org/~haven/dendrite/dendrite-0.13.8-vendor.tar.xz",
    "https://dev.gentoo.org/~haven/matrix-media-repo/matrix-media-repo-1.3.8-vendor.tar.xz",
    "https://dev.gentoo.org/~haven/matrix-sliding-sync/matrix-sliding-sync-0.99.19-vendor.tar.xz",
    "https://dev.gentoo.org/~haven/mattermost-calls-offloader/mattermost-calls-offloader-0.9.6-vendor.tar.xz",
    "https://dev.gentoo.org/~haven/mattermost-matrix-bridge/mattermost-matrix-bridge-0.1.12-vendor.tar.xz",
    # Dead upstreams / asset renames (follow-up)
    # jellyfin-bin: server tarballs removed from repo.jellyfin.org (410) and
    # GitHub releases ship no assets; masked in profiles/package.mask.
    "https://repo.jellyfin.org/releases/server/linux/stable/server/jellyfin-server_10.6.2_linux-amd64.tar.gz",
    "https://github.com/grafana/alloy/releases/download/v1.19.1/alloy-linux-amd64.zip",
    "https://github.com/jason-kuo/ormsgpack/archive/refs/tags/v1.12.2.tar.gz",
    "https://github.com/voidful/Distil/archive/refs/tags/v0.1.0.tar.gz",
    "https://github.com/readmeabook/readmeabook/archive/refs/tags/v1.2.1.tar.gz",
    "https://bintray.com/jfrog/jfrog-mc/download_file?file_path=linux/4.5.0/jfrog-mc-4.5.0-linux.tar.gz",
    "https://bintray.com/jfrog/jfrog-mc/download_file?file_path=linux/4.6.3/jfrog-mc-4.6.3-linux.tar.gz",
    "http://s.insynchq.com/builds/insync_1.0.26.31705_amd64.deb",
    "http://s.insynchq.com/builds/insync_1.0.26.31705_i386.deb",
    "http://s.insynchq.com/builds/insync_1.0.29.31750_amd64.deb",
    "http://s.insynchq.com/builds/insync_1.0.29.31750_i386.deb",
    "http://s.insynchq.com/builds/insync_1.0.34.31801-wheezy_amd64.deb",
    "http://s.insynchq.com/builds/insync_1.0.34.31801-wheezy_i386.deb",
    "http://s.insynchq.com/builds/insync_1.1.3.32034-wheezy_amd64.deb",
    "http://s.insynchq.com/builds/insync_1.1.3.32034-wheezy_i386.deb",
    "http://s.insynchq.com/builds/insync_1.2.8.35136-wheezy_amd64.deb",
    "http://s.insynchq.com/builds/insync_1.2.8.35136-wheezy_i386.deb",
    "http://s.insynchq.com/builds/insync-dolphin_1.0.26.31705_all.deb",
    "http://s.insynchq.com/builds/insync-dolphin_1.0.29.31750_all.deb",
    "http://s.insynchq.com/builds/insync-dolphin_1.0.34.31801-wheezy_all.deb",
    "http://s.insynchq.com/builds/insync-dolphin_1.1.3.32034-wheezy_all.deb",
    "http://s.insynchq.com/builds/insync-dolphin_1.2.8.35136-wheezy_all.deb",
    "http://s.insynchq.com/builds/insync-nautilus_1.0.26.31705_all.deb",
    "http://s.insynchq.com/builds/insync-nautilus_1.0.29.31750_all.deb",
    "http://s.insynchq.com/builds/insync-nautilus_1.0.34.31801-wheezy_all.deb",
    "http://s.insynchq.com/builds/insync-nautilus_1.1.3.32034-wheezy_all.deb",
    "http://s.insynchq.com/builds/insync-nautilus_1.2.8.35136-wheezy_all.deb",
    "http://s.insynchq.com/builds/insync-thunar_1.0.26.31705_all.deb",
    "http://s.insynchq.com/builds/insync-thunar_1.0.29.31750_all.deb",
    "http://s.insynchq.com/builds/insync-thunar_1.0.34.31801-wheezy_all.deb",
    "http://s.insynchq.com/builds/insync-thunar_1.1.3.32034-wheezy_all.deb",
    "http://s.insynchq.com/builds/insync-thunar_1.2.8.35136-wheezy_all.deb",
    "http://fisil.com/linux/wync_debian64_v2.0.233.deb",
    "http://fisil.com/linux/wync_debian64_v2.0.257.deb",
    "http://fisil.com/linux/wync_ubuntu64_v2.0.328.deb",
    # Stale ebuild: tag v0.3.1 deleted upstream (v0.3.5+ exist; follow-up: prune)
    "https://gitlab-ee.thehavennet.org.uk/ai-ml/scaffold-engine/-/archive/v0.3.1/scaffold-engine-v0.3.1.tar.gz",
}

_EBUILD_RE = re.compile(r"^(?P<PN>.+?)-(?P<PV>\d[^-]*?)(?:-r\d+)?\.ebuild$")
_VAR_ASSIGN_RE = re.compile(
    r'^(?P<name>[A-Z_][A-Z0-9_]*)=(?:"(?P<dq>[^"]*)"|\'(?P<sq>[^\']*)\'|(?P<raw>\S+))'
)
_RENAME_RE = re.compile(r"^(?P<url>https?://\S+?)\s*->\s*\S+$")
_EMPTY_SEGMENT_RE = re.compile(r"[-_/]\.[a-z0-9]+")


def _malformed(url: str) -> bool:
    """True if the URL contains an unexpanded placeholder (parser gap).

    Covers: empty host (``https:///path``), empty path segment (``a//b``),
    ``n/a`` placeholders, and empty variables at segment ends (``x-.tgz``).
    """
    if "n/a" in url:
        return True
    if _EMPTY_SEGMENT_RE.search(url):
        return True
    rest = url.split("://", 1)[1]
    if rest.startswith("/"):
        return True  # empty host
    path = rest.split("/", 1)[1] if "/" in rest else ""
    return "//" in path


def _parse_ebuild(path: Path) -> list[str]:
    """Return expanded SRC_URI distfile URLs for one ebuild."""
    text = path.read_text()
    m = _EBUILD_RE.match(path.name)
    if not m:
        return []
    pn, pv = m.group("PN"), m.group("PV")
    if pv == "9999":
        return []  # live ebuild: SRC_URI is not fetched
    pr = ""
    rm = re.search(r"-r(\d+)\.ebuild$", path.name)
    if rm:
        pr = rm.group(1)
    vars_ = {
        "PN": pn,
        "PV": pv,
        "P": f"{pn}-{pv}",
        "PR": pr,
        "PF": f"{pn}-{pv}" + (f"-r{pr}" if pr else ""),
    }
    for line in text.splitlines():
        am = _VAR_ASSIGN_RE.match(line.strip())
        if am and am.group("name") not in vars_:
            vars_[am.group("name")] = (
                am.group("dq") or am.group("sq") or am.group("raw") or ""
            )

    if re.search(r"RESTRICT=.*\bfetch\b", text):
        return []

    urls: list[str] = []
    for block in re.finditer(r'SRC_URI\+?="(?P<body>[^"]*)"', text, re.S):
        for token in block.group("body").split():
            if not token.startswith("http"):
                continue
            rm2 = _RENAME_RE.match(token)
            url = rm2.group("url") if rm2 else token
            url = re.sub(
                r"\$\{([A-Z0-9_]+)\}", lambda mm: vars_.get(mm.group(1), ""), url
            )
            if "$" in url or "mirror://" in url or _malformed(url):
                continue
            host = url.split("://", 1)[1].split("/", 1)[0]
            if host in SKIP_HOSTS:
                continue
            urls.append(url)
    return urls


def _fetch_ok(url: str) -> tuple[str, bool]:
    def _try(method: str, extra_headers: dict | None = None) -> bool:
        headers = {"User-Agent": _USER_AGENT}
        if extra_headers:
            headers.update(extra_headers)
        req = Request(url, method=method, headers=headers)
        with urlopen(req, timeout=15) as resp:
            return 200 <= resp.status < 400

    try:
        return url, _try("HEAD")
    except Exception:
        try:
            return url, _try("GET", {"Range": "bytes=0-0"})
        except Exception:
            return url, False


def _all_src_uri_urls() -> dict[str, Path]:
    """Map unique distfile URL -> first ebuild that references it."""
    seen: dict[str, Path] = {}
    for path in sorted(OVERLAY_ROOT.rglob("*.ebuild")):
        if "metadata/md5-cache" in str(path):
            continue
        for url in _parse_ebuild(path):
            seen.setdefault(url, path)
    return seen


def _fetch_failures() -> dict[str, Path]:
    urls = _all_src_uri_urls()
    failures: dict[str, Path] = {}
    with ThreadPoolExecutor(max_workers=16) as pool:
        futures = {pool.submit(_fetch_ok, url): url for url in urls}
        for fut in as_completed(futures):
            url, ok = fut.result()
            if not ok:
                failures[url] = urls[url]
    # Sequential retry pass: parallel runs can trip rate limiters (e.g.
    # gitlab-ee). Only URLs that still fail after retry are real breakage.
    for url in list(failures):
        if _fetch_ok(url)[1]:
            del failures[url]
    return failures


def test_no_new_broken_urls():
    failures = _fetch_failures()
    new = {u: p for u, p in failures.items() if u not in KNOWN_BROKEN}
    assert not new, (
        "SRC_URI distfile URLs that failed to fetch and are NOT in KNOWN_BROKEN "
        "(new breakage — investigate):\n"
        + "\n".join(
            f"  {url}  (first referenced by {path})"
            for url, path in sorted(new.items())
        )
    )


def test_change_targets_fixed():
    failures = _fetch_failures()
    still_broken = {u: p for u, p in failures.items() if u in CHANGE_TARGETS}
    assert not still_broken, (
        "Change targets (fix-ebuild-bump-failures) still failing to fetch:\n"
        + "\n".join(
            f"  {url}  (first referenced by {path})"
            for url, path in sorted(still_broken.items())
        )
    )
