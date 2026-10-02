## Task 1.1 — Mask sheepdog and bbcp

**Goal:** both packages recorded in `profiles/package.mask` with a dated dead-upstream reason.
**Files:** `profiles/package.mask`
**Steps:**
1. Append:
   ```
   # dead upstream: git://sheepdog.git.sf.net (transport + project defunct) — 2026-08-13
   sys-cluster/sheepdog
   # dead upstream: bitbucket.org/piotrkarbowski/bbcp removed — 2026-08-13
   net-misc/bbcp
   ```
2. Keep the ebuilds in the tree (policy: mask rather than delete).
**Verify:** `grep -n 'sheepdog\|bbcp' profiles/package.mask`
**Commit:** `profiles: mask sys-cluster/sheepdog and net-misc/bbcp (dead upstream)`

---

## Task 1.2 — Regenerate metadata cache

**Goal:** the local portage cache reflects the masks.
**Files:** none.
**Steps:**
1. `sudo -n egencache --repo=haven-overlay --update`
**Verify:** command completes without error
**Commit:** n/a

---

## Task 1.3 — ebuild-updater stops chasing them

**Goal:** `ebuild-updater status` no longer lists sheepdog/bbcp as refreshable.
**Files:** none (may require `ebuild-updater.toml` hold entries if the updater ignores masks).
**Steps:**
1. Run `ebuild-updater status` from `/var/db/repos/haven-overlay`.
2. If the updater still lists them, add holds to `ebuild-updater.toml`.
**Verify:** packages absent from updater output
**Commit:** `ebuild-updater.toml: hold sheepdog and bbcp` (only if needed)

---

## Task 2.1 — Gate skips masked packages

**Goal:** `verify-git-uris.sh` does not fail on masked ebuilds.
**Files:** `scripts/verify-git-uris.sh`
**Steps:**
1. Parse `profiles/package.mask` and skip matching `cat/pkg` entries (honour `=`/`*` suffix forms).
2. Keep an `--include-masked` flag for audits.
**Verify:** with sheepdog/bbcp masked, `sudo .../verify-git-uris.sh` exits 0
**Commit:** `scripts: skip masked packages in verify-git-uris.sh`

---

## Task 3.1 — Full gate run

**Goal:** end-to-end confirmation.
**Files:** none.
**Steps:**
1. `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh`
**Verify:** exit 0 (masked packages skipped)
**Commit:** n/a
