## Task 1.1 — Identify the real codex upstream

**Goal:** a named, verifiable upstream repository for the codex package.
**Files:** none.
**Steps:**
1. Research the codex project this ebuild packages (candidate: `github.com/openai/codex`); confirm it publishes git tags and has a licence compatible with the current ebuild's metadata.
2. Record the verified https clone URL.
**Verify:** `sudo -u portage git ls-remote https://github.com/openai/codex.git HEAD` (or the confirmed candidate) returns a HEAD ref
**Commit:** n/a

---

## Task 1.2 — Prove the regression state

**Goal:** demonstrate the current ebuild fails to fetch (RED) before fixing.
**Files:** none.
**Steps:**
1. `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` — confirm codex-9999 is flagged (ssh URI, wrong repo).
**Verify:** script output lists codex-9999 as skipped/failed
**Commit:** n/a

---

## Task 2.1 — Point the ebuild at the real upstream

**Goal:** `EGIT_REPO_URI` and `HOMEPAGE` reference the verified public upstream.
**Files:** `app-misc/codex/codex-9999.ebuild`
**Steps:**
1. Replace `EGIT_REPO_URI="ssh://.../ai-ml/better-brain.git"` with `EGIT_REPO_URI="https://<verified-upstream>.git"` (public https only — no ssh, no `file://`).
2. Replace `HOMEPAGE` with the project web URL.
3. If the verified upstream publishes tags, consider pinning `EGIT_COMMIT` for reproducible builds.
**Verify:** `grep -n 'EGIT_REPO_URI\|HOMEPAGE' app-misc/codex/codex-9999.ebuild` shows public https values
**Commit:** `app-misc/codex: point EGIT_REPO_URI at real upstream`

---

## Task 2.2 — Gate goes green

**Goal:** verify-git-uris.sh no longer flags codex.
**Files:** none.
**Steps:**
1. `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh`
**Verify:** codex-9999 URI probes OK; no FAIL lines for it
**Commit:** n/a

---

## Task 2.3 — Clean install smoke test

**Goal:** the ebuild builds and installs from the new URI.
**Files:** none.
**Steps:**
1. `sudo ebuild app-misc/codex/codex-9999.ebuild clean install`
2. `sudo -u portage ebuild app-misc/codex/codex-9999.ebuild unpack` (fetch as the real build user).
**Verify:** install completes; unpack clones the correct project
**Commit:** n/a

---

## Task 3.1 — Mask if no public upstream

**Goal:** codex is recorded as masked if it cannot be fixed.
**Files:** `profiles/package.mask`
**Steps:**
1. Append `app-misc/codex` with comment `# no public upstream (2026-08-13 audit)`.
**Verify:** `grep codex profiles/package.mask`
**Commit:** `profiles: mask app-misc/codex (no public upstream)`

---

## Task 3.2 — No discover hook chases codex

**Goal:** ebuild-updater does not attempt to refresh codex.
**Files:** `metadata/discover-hooks/**` (if an entry exists)
**Steps:**
1. Check `grep -r codex metadata/discover-hooks/`; remove or neutralise any entry.
**Verify:** grep returns nothing
**Commit:** `metadata: drop codex discover hook`

---

## Task 4.1 — Full gate run

**Goal:** end-to-end confirmation.
**Files:** none.
**Steps:**
1. `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh`
**Verify:** exit 0 (or codex masked-and-skipped)
**Commit:** n/a
