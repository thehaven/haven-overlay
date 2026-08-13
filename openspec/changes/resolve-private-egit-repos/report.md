## Symptom

Seven ebuilds cannot fetch their sources: gitlab-ee projects `ai-ml/cortex`, `ai-ml/librarian` and `gentoo/docker-updater` are private, so anonymous fetches return 404 and git-r3 dies in `src_unpack` with "Unable to fetch from any of EGIT_REPO_URI".

## Environment

- Gentoo (dev host and webhost), portage user with `FEATURES=userpriv`
- haven-overlay at `/var/db/repos/haven-overlay`
- Remote: `https://gitlab-ee.thehavennet.org.uk` (gitlab-ee)
- Discovered during the 2026-08-13 incident audit (`scripts/verify-git-uris.sh`)

## Reproduction Steps

1. `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/cortex.git HEAD`
2. Observe gitlab-ee returning 404 ("The project you were looking for could not be found") to the anonymous portage user
3. `emerge =app-misc/cortex-9999` — dies in `src_unpack`: `Unable to fetch from any of EGIT_REPO_URI`

## Expected vs Actual

**Expected:** the ebuilds fetch anonymously from a public remote (the rest of the overlay does exactly this).
**Actual:** `ai-ml/cortex`, `ai-ml/librarian`, `gentoo/docker-updater` are private; the portage user has no credentials, every fetch 404s, and all seven ebuilds are unbuildable. The tree still carries `file://`/`ssh://` URIs for them (`docker-updater` 0.2.0/0.3.0 = `file://`, 0.1.0 = scp-style ssh, cortex ×3 + librarian-9999 = `file://`), all flagged by `verify-git-uris.sh`.
