## Symptom

`app-misc/codex/codex-9999.ebuild` references the wrong upstream: `EGIT_REPO_URI` and `HOMEPAGE` both point at `ai-ml/better-brain.git` (via `ssh://`), and no `ai-ml/codex` project exists on gitlab-ee — the ebuild is a copy-paste of better-brain's.

## Environment

- Gentoo, haven-overlay at `/var/db/repos/haven-overlay`
- Discovered during the 2026-08-13 audit (`scripts/verify-git-uris.sh`)

## Reproduction Steps

1. `grep -n 'EGIT_REPO_URI\|HOMEPAGE' app-misc/codex/codex-9999.ebuild`
2. Observe better-brain references (`ssh://.../ai-ml/better-brain.git`)
3. `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/codex.git HEAD` → 404 (project does not exist)

## Expected vs Actual

**Expected:** codex-9999 fetches the codex project's source anonymously.
**Actual:** the ebuild points at better-brain's repo over ssh (unfetchable by the portage user), and no codex repository exists on gitlab-ee at all — the package cannot build under any circumstance.
