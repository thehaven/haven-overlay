## Task 1.1 — Make ai-ml/cortex public

**Goal:** `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/cortex.git HEAD` returns a HEAD ref.
**Files:** none (gitlab-ee project settings / API).
**Steps:**
1. In gitlab-ee: Project `ai-ml/cortex` → Settings → General → Visibility → Public (or `PUT /projects/ai-ml%2Fcortex` with `visibility: public` via an authenticated API token).
2. Confirm visibility: anonymous browser view of the project page loads.
**Verify:** `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/cortex.git HEAD`
**Commit:** n/a (repo-side action)

---

## Task 1.2 — Make ai-ml/librarian public

**Goal:** anonymous `git ls-remote` for librarian.git succeeds.
**Files:** none.
**Steps:**
1. Same visibility change for `ai-ml/librarian`.
**Verify:** `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/librarian.git HEAD`
**Commit:** n/a

---

## Task 1.3 — Make gentoo/docker-updater public

**Goal:** anonymous `git ls-remote` for docker-updater.git succeeds.
**Files:** none.
**Steps:**
1. Same visibility change for `gentoo/docker-updater`.
**Verify:** `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/gentoo/docker-updater.git HEAD`
**Commit:** n/a

---

## Task 2.1 — Migrate EGIT_REPO_URI to https for public repos

**Goal:** all seven ebuilds reference `https://gitlab-ee.thehavennet.org.uk/{ai-ml,gentoo}/<name>.git`; no `file://`/ssh URI remains for these packages.
**Files:**
- `app-misc/cortex/cortex-0.7.2.ebuild`, `cortex-0.8.3.ebuild`, `cortex-9999.ebuild`
- `dev-util/librarian/librarian-9999.ebuild`
- `app-containers/docker-updater/docker-updater-0.1.0.ebuild`, `docker-updater-0.2.0.ebuild`, `docker-updater-0.3.0.ebuild`
**Steps:**
1. Replace `EGIT_REPO_URI="file:///storage/..."` (cortex, librarian, docker-updater 0.2.0/0.3.0) and `EGIT_REPO_URI="git@...:gentoo/docker-updater.git"` (0.1.0) with the verified public https URL.
2. Update `HOMEPAGE` if it still carries a private/ssh reference.
**Verify:** `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` → the seven URIs probe green
**Commit:** `app-misc/cortex: switch EGIT_REPO_URI to gitlab-ee https`

---

## Task 2.2 — Run the URI gate

**Goal:** gate exits 0 with the migrated URIs.
**Files:** none.
**Steps:**
1. `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh`
**Verify:** exit code 0; no FAIL lines for cortex/librarian/docker-updater
**Commit:** n/a

---

## Task 2.3 — Real fetch smoke test as portage user

**Goal:** `emerge --fetchonly` succeeds for a representative migrated package.
**Files:** none.
**Steps:**
1. `sudo -u portage emerge --fetchonly =app-misc/cortex-9999` (git-r3 clones over https).
**Verify:** fetch completes; no "Unable to fetch" error
**Commit:** n/a

---

## Task 3.1 — Mask still-private packages

**Goal:** any repo that stays private has its packages recorded in `profiles/package.mask`.
**Files:** `profiles/package.mask`
**Steps:**
1. Append `=app-misc/cortex-*` (or specific versions), `=dev-util/librarian-9999`, `=app-containers/docker-updater-*` as needed with a comment: `# private gitlab-ee repo (unfetchable by portage) — 2026-08-13`.
**Verify:** `grep -n "<pkg>" profiles/package.mask`
**Commit:** `profiles: mask <pkg> (private gitlab-ee repo)`

---

## Task 3.2 — Skip masked packages in the gate

**Goal:** `verify-git-uris.sh` ignores ebuilds masked in `profiles/package.mask` so residual flags are actionable.
**Files:** `scripts/verify-git-uris.sh`
**Steps:**
1. Parse `profiles/package.mask` (plain atoms; honour `=`/`*` suffixes) and skip matching `cat/pkg` entries.
2. Keep an explicit `--include-masked` flag for audits.
**Verify:** with masked entries present, `sudo .../verify-git-uris.sh` exits 0
**Commit:** `scripts: skip masked packages in verify-git-uris.sh`

---

## Task 4.1 — Full gate run

**Goal:** end-to-end confirmation.
**Files:** none.
**Steps:**
1. `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh`
**Verify:** exit 0
**Commit:** n/a

---

## Task 4.2 — ebuild-updater status clean

**Goal:** `ebuild-updater status` no longer flags the resolved packages.
**Files:** none.
**Steps:**
1. Run `ebuild-updater status` from `/var/db/repos/haven-overlay`.
**Verify:** resolved packages absent from stale/unfetchable output
**Commit:** n/a
