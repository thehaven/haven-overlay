## Hypothesis

`codex-9999.ebuild` was copy-pasted from `better-brain-9999.ebuild` and the upstream identity (URI + homepage) was never updated to the real codex project.

## Evidence

- `scripts/verify-git-uris.sh` output: `ssh://g<redacted>/ai-ml/better-brain.git` for codex-9999 → skipped-and-failed (ssh is not fetchable by the portage user).
- Anonymous gitlab-ee API: `ai-ml/codex` → 404 — the project does not exist.
- `HOMEPAGE` carries the same `ssh://.../ai-ml/better-brain.git` value — the whole header block was copied.
- No other codex ebuild exists anywhere in the overlay (single-package blast radius).
- Upstream candidates exist in the public ecosystem (e.g. `github.com/openai/codex`); the intended upstream was never confirmed in-tree.

## Root Cause

Copy-paste bug: codex-9999 was cloned from better-brain's ebuild including its `EGIT_REPO_URI`/`HOMEPAGE`; the real codex upstream was never identified or wired in.

## Blast Radius

- Single ebuild: `app-misc/codex/codex-9999.ebuild`.
- If the real upstream is public (e.g. GitHub), the fix is a two-line URI/homepage change; otherwise the package should be masked per repo policy.
- No other package depends on codex.
