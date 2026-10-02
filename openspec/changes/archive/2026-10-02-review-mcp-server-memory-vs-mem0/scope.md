# Scope: review mcp-server-memory (npm) vs mem0-mcp

## Files Under Review

| Path | Purpose | Status |
|---|---|---|
| `dev-util/mcp-server-memory/mcp-server-memory-2026.8.31.ebuild` | Ebuild for the npm `@modelcontextprotocol/server-memory` package | installed 2026-09-01, portage 2026.8.31 bump on 2026-09-01 (commit `cc7e8228`) |
| `~/.config/mcp-forge/registry.yaml` (entries `memory` and `mem0`) | Registry entry: `memory` references the npm package; `mem0` references haven's docker-compose service | `memory` disabled 2026-09-04 (this review); `mem0` enabled and verified |
| `/var/db/pkg/dev-util/mcp-server-memory-2026.8.31/` | Installed package manifest | installed since 2026-09-01 |
| `/usr/lib64/node_modules/@modelcontextprotocol/server-memory/` | npm package install location | confirmed present; fails to run because package writes to a read-only path under `/usr/lib64/` |
| `/etc/portage/package.use` for `dev-util/mcp-meta` | Whether mem0 is still USE-flag-gated through `mcp-meta`; affects whether `mcp-server-memory` is a peer listed there | confirmed `mcp-meta` does NOT list mcp-server-memory (only ai-compressor etc.); reviewed and rejected |

## Blast Radius

Removing the `memory` registry entry and the `dev-util/mcp-server-memory`
ebuild affects:

- **Agents that reference `memory` in their `mcp-forge` profile** — none
  currently. The only profile (`opencode`) lists `mcp-mesh` and `mem0`.
- **Agents that have `dev-util/mcp-server-memory` installed** — only the
  single host running the haven-overlay `master` branch; package is local.
- **`mcp-server-tree-sitter`, `mcp-meta`, etc.**: independent (different packages).
- **External consumers of the haven-overlay**: none (single-operator personal overlay).

## Out of Scope

- Replacing `memory` with `mem0` in any third-party config (no profiles here reference `memory`).
- Refactoring `mcp-meta` (which IS the meta-package for many MCP servers)
  to drop `memory` from its sub-list — confirmed mcp-meta does not
  reference `memory` in its USE flags, so no change there.

## Files to Read Next (in order)

1. `dev-util/mcp-server-memory/Manifest` (sha sums, version metadata).
2. `metadata/md5-cache/dev-util/mcp-server-memory-2026.8.31` (portage
   cache — confirm the installed package matches the ebuild).
3. The `memory` and `mem0` registry entries in `registry.yaml` (already
   captured in findings.md).
4. `mcp-mesh doctor` output from the 2026-09-04 mem0 verification
   session.
