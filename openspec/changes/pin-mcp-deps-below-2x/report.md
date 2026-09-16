## Symptom

Every ebuild in the overlay that depends on `dev-python/mcp` without an
upper bound resolves to mcp 2.x on a fresh install and dies at import
with `ModuleNotFoundError: No module named 'mcp.server.fastmcp'` — mcp
2.x removed the FastMCP API that these packages import.

## Environment

- Overlay: haven-overlay (master), Gentoo Linux
- `dev-python/mcp` packaged versions: 1.27.0–1.28.1, 2.0.0–2.2.0 (no 1.29.x)
- Portage resolves unbounded deps to the highest version → 2.2.0

## Reproduction Steps

1. `emerge -1 '=app-vuln/semgrep-1.177.0'` on a system without mcp
   installed (or with mcp 2.x forced).
2. Run `semgrep mcp` (or import `semgrep.mcp`).
3. Observe `ModuleNotFoundError: No module named 'mcp.server.fastmcp'`.

Same failure for `dev-util/ebuild-updater` (mcp mode),
`dev-python/x402` (`mcp/server.py` imports `FastMCP` + `Context`), and
`dev-util/mcp-pagerduty` (`pagerduty_mcp/server.py` line 5).

## Expected vs Actual

**Expected:** the mcp dependency resolves to a 1.x version whose
`mcp.server.fastmcp` module exists (overlay ships 1.28.1, verified
working with skillspector and stele).

**Actual:** the dep resolves to mcp 2.2.0, whose `fastmcp.py` is a
16-line shim that raises ModuleNotFoundError. The failure is a runtime
import error, not a build error, so it surfaces only when the user
actually runs the MCP server.

## Fix

Pin `>=dev-python/mcp-1.28.1[${PYTHON_USEDEP}] <dev-python/mcp-2[${PYTHON_USEDEP}]`
in every ebuild whose source imports `mcp.server.fastmcp` (semgrep ×10,
ebuild-updater ×11, x402 ×10, mcp-pagerduty ×1; mcp-alertmanager to be
verified). Packages with no fastmcp reference (anthropic, ai-compressor,
serena-agent, headroom-ai, jc-mcp) are left unpinned and re-verified on
bump. House precedent: `dev-python/mcp-server-time` pins `>=1.28.1 <3`
with an mcp2-compat patch; packages without a compat patch need `<2`.
