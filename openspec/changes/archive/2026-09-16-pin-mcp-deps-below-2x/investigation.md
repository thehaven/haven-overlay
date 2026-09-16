## Existing context (vault)

- `Projects/haven-overlay/findings.md` (2026-09-16): mcp-2.x FastMCP
  landmine — mcp 2.x removed `mcp.server.fastmcp` (the 2.2.0
  `fastmcp.py` is a 16-line shim that raises ModuleNotFoundError).
  The overlay ships mcp 1.27.0–1.28.1 and 2.0.0–2.2.0 but no 1.29.x,
  so any unpinned `dev-python/mcp` dep resolves to 2.2.0 on a fresh
  install and breaks at import.
- Same session: `add-skillspector-mcp-wiring` change pinned
  skillspector and stele to `>=dev-python/mcp-1.28.1 <dev-python/mcp-2`
  (house precedent: `dev-python/mcp-server-time-2026.8.18` pins
  `>=1.28.1 <3` with an mcp2-compat patch; packages without a compat
  patch need `<2`). The remaining unpinned consumers were flagged for
  follow-up.

## Hypothesis

Every ebuild in the overlay that depends on `dev-python/mcp` without an
upper bound is at risk of resolving to mcp 2.x and breaking at import —
but only if the package actually imports the removed `mcp.server.fastmcp`
API. Packages that use the mcp SDK's client or low-level server APIs may
be 2.x-safe. The fix must be evidence-based: pin `<2` only where the
source imports fastmcp, and verify the rest.

## Evidence

Audit of every `dev-python/mcp` dep in the overlay (2026-09-16), with
source-level verification of fastmcp imports:

**Verified fastmcp importers — MUST pin `>=1.28.1 <2` (32 ebuilds):**
- `app-vuln/semgrep` 1.168.0–1.177.0 (10): installed source has 4 files
  importing `mcp.server` (commands/mcp.py, mcp/server.py).
- `dev-util/ebuild-updater` 2.8.2–2.10.6, 9999 (11): installed source
  has 1 file importing `mcp.server`.
- `dev-python/x402` 2.14.0–2.23.0 (10): distfile `mcp/server.py` imports
  `from mcp.server.fastmcp import FastMCP` and `Context` (lines 8, 92).
- `dev-util/mcp-pagerduty` 0.17.0 (1): distfile
  `pagerduty_mcp/server.py` line 5 imports `from mcp.server.fastmcp import FastMCP`.
- Already fixed: `app-vuln/skillspector`, `app-admin/stele` (3).

**No fastmcp reference in installed versions — likely 2.x-safe, verify on bump:**
- `dev-python/anthropic` 0.121.0–1.6.0 (10): extras block
  `">=dev-python/mcp-1.0"`; 0 files reference fastmcp.
- `app-misc/ai-compressor` 9999 (1): 0 files reference fastmcp.
- `dev-python/serena-agent` 1.5.3–1.7.0 (4): 0 files reference fastmcp.
- `dev-python/headroom-ai` 0.30.0–0.37.0 (11): `>=dev-python/mcp-1.0.0`
  + optfeature; 0 files reference fastmcp.
- `dev-python/jc-mcp` 1.0.0, 1.25.6, 1.25.7 (3): 0 files reference fastmcp.

**Needs source verification (distfile not fetched):**
- `dev-util/mcp-alertmanager` 1.1.0, 1.2.0 (2): only 1.1.0 tarball
  present; extraction produced no source dir to grep.

**Already correctly pinned:**
- `dev-python/fastmcp` 4.0.0–4.0.4 (5): `>=2.0.0 <3.0.0` — mcp-2-native,
  correct as-is.
- `dev-python/openworker` 0.1.7–0.2.1 (3): `>=1.1 <2` — correct as-is.

## Root cause analysis

The overlay added mcp 2.0.0–2.2.0 ebuilds (official PyPI mcp SDK) while
upstream packages still target the 1.x FastMCP API. Portage resolves
unbounded `dev-python/mcp` deps to the highest version, so any fresh
install of semgrep/ebuild-updater/x402/mcp-pagerduty (and previously
skillspector/stele) pulls mcp 2.x and dies at import with
ModuleNotFoundError. The `>=1.28.1 <2` bound is the correct fix: 1.28.1
is the newest packaged 1.x (verified working with skillspector and
stele), and `<2` blocks the FastMCP removal.

**Blast radius if untreated**: every fresh install of the four verified
packages breaks at first MCP invocation; the failure is a runtime import
error, not a build error, so it surfaces only when the user actually
runs the MCP server.

## Direction

1. Pin `>=dev-python/mcp-1.28.1[${PYTHON_USEDEP}] <dev-python/mcp-2[${PYTHON_USEDEP}]`
   in the 32 verified-fastmcp ebuilds (semgrep ×10, ebuild-updater ×11,
   x402 ×10, mcp-pagerduty ×1), with a one-line comment above the
   RDEPEND string (comments inside the quoted string are literal atom
   text — see gentoo-ebuild skill Common Mistakes, 2026-09-16).
2. Verify mcp-alertmanager source (fetch 1.2.0 distfile); pin if it
   imports fastmcp.
3. Leave the no-fastmcp group (anthropic, ai-compressor, serena-agent,
   headroom-ai, jc-mcp) unpinned; add a bump-hook note or comment that
   the mcp dep must be re-verified against fastmcp imports on each bump.
4. Validation: `ebuild info` on all touched ebuilds, `emerge --pretend`
   on one representative per package, `pytest scripts/tests/`,
   `openspec validate --all`.
