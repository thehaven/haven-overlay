## Symptom

`app-misc/mem0-mcp/mem0-mcp-0.1.0.ebuild` pins `EGIT_COMMIT=v0.1.0` (commit `55a23354`), but that tag exists only in the operator's local clone. gitlab-ee `ai-ml/mem0-mcp` has no tags and a diverged history, so the pinned build cannot fetch.

## Environment

- Gentoo, haven-overlay at `/var/db/repos/haven-overlay`
- Remote: `https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp.git`
- Discovered during the 2026-08-13 audit (`scripts/verify-git-uris.sh` + tag probes)

## Reproduction Steps

1. `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp.git 'refs/tags/*'` → no tags at all
2. Note the divergence: gitlab `main` = `8dc163ca`; local `main` = `229f17d9`
3. `emerge =app-misc/mem0-mcp-0.1.0` → git-r3 cannot resolve commit/tag `v0.1.0` on the remote

## Expected vs Actual

**Expected:** `v0.1.0` resolves on the remote so the pinned ebuild fetches deterministically.
**Actual:** the tag exists only in the local clone; the remote history diverged (local history was rewritten or the tag was never pushed), so the 0.1.0 build always fails. `mem0-mcp-9999` (tracks `main`) builds fine.
