## Hypothesis

The local clone's history was rewritten (or the tag was created locally and never pushed). gitlab-ee carries a different `main` lineage with no tags, so the pin in the versioned ebuild cannot resolve remotely.

## Evidence

- gitlab `main` = `8dc163ca`; local `main` = `229f17d9` — divergent histories.
- Local tag `v0.1.0` = `55a23354` is not reachable from any remote ref: `ls-remote` shows zero `refs/tags/*`.
- `mem0-mcp-9999.ebuild` (no pin) works and was migrated to https gitlab-ee in the 2026-08-13 fix; `mem0-mcp-0.1.0.ebuild` was migrated to the same https URL but remains unbuildable until the pin resolves.
- No other ebuild depends on the 0.1.0 pin.

## Root Cause

Tag `v0.1.0` (`55a23354`) was never published to gitlab-ee (or was orphaned by a local rewrite); the versioned ebuild's `EGIT_COMMIT` pin cannot resolve against the remote.

## Blast Radius

- Single ebuild: `app-misc/mem0-mcp/mem0-mcp-0.1.0.ebuild`.
- Users can fall back to `mem0-mcp-9999`.
- If the tag cannot be restored, the 0.1.0 ebuild should be retired (removed or masked); the 9999 ebuild is unaffected either way.
