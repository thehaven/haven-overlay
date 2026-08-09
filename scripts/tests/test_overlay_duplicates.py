"""Repo-wide duplicate guard: no two packages may share an upstream identity
unless explicitly allowlisted (monorepo splits, bin/source variants, virtuals).

This is the generalized version of the lesson from the same-day duplicate
packaging of prime-agent (app-misc/ vs dev-util/) and the 14 duplicate pairs
removed on 2026-08-08 (b2, trivy, readarr, lidarr, hcom, rtk, litellm and six
opencode plugin renames). A new duplicate in any category fails here before
commit.
"""

import re
from pathlib import Path
from collections import defaultdict

OVERLAY_ROOT = Path(__file__).resolve().parent.parent.parent

# Upstreams that legitimately map to more than one package:
# monorepo multi-package repos, bin/source splits, and virtuals.
ALLOWED_SHARED_UPSTREAM = {
    "github.com:NousResearch/hermes-agent",          # hermes + hermes-plugin-*
    "github.com:modelcontextprotocol/servers",       # mcp-server-*, mcp-postgres, mcp-slack
    "npm:@modelcontextprotocol",                     # same repo via npm identities
    "github.com:kubernetes/kubernetes",              # kubeadm, kubectl, kubelet, ...
    "github.com:goharbor/harbor",                    # harbor + component packages
    "github.com:open-telemetry/opentelemetry-python",         # otel API/SDK/exporters
    "github.com:open-telemetry/opentelemetry-python-contrib",  # otel instrumentation
    "github.com:microsoft/presidio",                 # presidio-analyzer/anonymizer
    "github.com:yungwine/pytoniq",                   # pytoniq + pytoniq-core
    "github.com:plur-ai/plur",                       # plur-cli + plur-mcp
    "npm:@plur-ai",                                  # same repo via npm identities
    "github.com:DefinitelyTyped/DefinitelyTyped",    # types-* stubs
    "github.com:python/typeshed",                    # types-* stubs
    "github.com:oven-sh/bun",                        # bun + bun-bin
    "github.com:obsidianmd/obsidian-releases",       # obsidian + obsidian-bin
    "github.com:kasmtech/KasmVNC",                   # kasmvnc + kasmvnc-bin
    "github.com:rust-lang/rust-analyzer",            # rust-analyzer + rust-analyzer-bin
    "github.com:OpenAPITools/openapi-generator",     # openapi-generator + -bin
    "github.com:sheeki03/tirith",                    # tirith + tirith-bin
    "github.com:anomalyco/opencode",                 # opencode, -bin, -plugins, -themes, lsp-meta
    "github.com:rusiaaman/wcgw",                     # mcp-meta virtual + mcp-server-wcgw
    "gitlab-ee.thehavennet.org.uk:haven/gentoo-distfiles",  # language servers from our mirror
    "github.com:PrimeIntellect-ai/prime-agent",      # prime-agent + prime-agent-runtime
}

# Package names legitimately present in more than one non-account category:
# distinct tools that happen to share a name (documented, not duplicates).
ALLOWED_NAME_COLLISIONS = {
    "yq",  # app-misc/yq (kislyuk, Python) vs dev-go/yq (mikefarah, Go)
}


def _upstream_keys(text: str) -> set[str]:
    keys = set()
    for m in re.finditer(
        r"https://(?:www\.)?(github\.com|gitlab[^/]*)/([A-Za-z0-9_.-]+)/([A-Za-z0-9_.-]+)/?",
        text,
    ):
        host, owner, repo = m.group(1), m.group(2), m.group(3)
        if repo in ("archive", "releases", "tree", "blob", "issues", "tags"):
            continue
        keys.add(f"{host}:{owner}/{repo}")
    for m in re.finditer(r"registry\.npmjs\.org/([^/\"\s]+)", text):
        keys.add(f"npm:{m.group(1)}")
    for m in re.finditer(r"pypi\.org/project/([^/\"\s]+)", text):
        keys.add(f"pypi:{m.group(1)}")
    return keys


def test_no_shared_upstream_outside_allowlist():
    groups: dict[str, set[str]] = defaultdict(set)
    for e in OVERLAY_ROOT.glob("*/*/*.ebuild"):
        for key in _upstream_keys(e.read_text(errors="ignore")):
            groups[key].add(f"{e.parts[0]}/{e.parts[1]}")
    offenders = {
        key: pkgs
        for key, pkgs in groups.items()
        if len(pkgs) > 1 and key not in ALLOWED_SHARED_UPSTREAM
    }
    assert not offenders, (
        "upstream identity shared by multiple packages; add the duplicate to "
        f"the allowlist ONLY if intentional: {offenders}"
    )


def test_package_name_unique_outside_allowlist():
    names: dict[str, set[str]] = defaultdict(set)
    for e in OVERLAY_ROOT.glob("*/*/*.ebuild"):
        names[e.parts[1]].add(e.parts[0])
    offenders = {}
    for name, cats in names.items():
        real = cats - {"acct-group", "acct-user"}
        if len(real) > 1 and name not in ALLOWED_NAME_COLLISIONS:
            offenders[name] = sorted(real)
    assert not offenders, (
        f"package name in multiple categories (collision risk): {offenders}"
    )
