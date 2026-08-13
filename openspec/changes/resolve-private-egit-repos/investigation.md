## Hypothesis

The three upstream projects are private on gitlab-ee. Anonymous clients (the portage user has no credentials configured) receive 404, which gitlab-ee deliberately returns for private projects to avoid leaking their existence.

## Evidence

- `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/cortex.git HEAD` → 404 (project not found to anonymous caller).
- Same 404 for `ai-ml/librarian.git` and `gentoo/docker-updater.git`.
- The docker-updater local clone's `origin` contains a PAT-embedded URL — proof the project exists and is merely private (a non-existent project would 404 with credentials too).
- `scripts/verify-git-uris.sh` flags all seven affected ebuilds (cortex 0.7.2/0.8.3/9999, librarian-9999, docker-updater 0.1.0/0.2.0/0.3.0): `file://` probes fail for the portage user, ssh URIs are skipped-and-failed.

## Root Cause

`ai-ml/cortex`, `ai-ml/librarian` and `gentoo/docker-updater` are private gitlab-ee projects. The portage user cannot authenticate, so every anonymous fetch returns 404 and git-r3 aborts in `src_unpack`.

## Blast Radius

- 7 ebuilds: `app-misc/cortex` 0.7.2, 0.8.3, 9999; `dev-util/librarian` 9999; `app-containers/docker-updater` 0.1.0, 0.2.0, 0.3.0.
- `ebuild-updater` discovery hooks keep refreshing these repos and will re-report them as stale/unfetchable until resolved.
- Class-level: any future ebuild pointed at a private gitlab-ee repo hits the same wall — `scripts/verify-git-uris.sh` now catches this class before a batch emerge fails.
