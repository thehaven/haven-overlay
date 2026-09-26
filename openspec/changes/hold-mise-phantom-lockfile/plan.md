## Task 1.1 — Add `dev-util/mise` to the hold list

**Goal:** `dev-util/mise` is appended to the `hold` array in
`/var/db/repos/haven-overlay/ebuild-updater.toml` with a comment citing the
phantom-crate probe evidence; `ebuild-updater` no longer bumps mise on
future nightly runs.

**Files:**
- `/var/db/repos/haven-overlay/ebuild-updater.toml`

**Steps:**
1. Open the file; locate the existing phantom-crate block (lines 47-63) that
   documents `ast-serialize`, `jsonschema-rs`, `tirith`, `syntax-checker`,
   `tree-sitter-language-pack`, `agnix`.
2. Append one new entry, `"dev-util/mise",` immediately after `agnix` (the
   last entry in the block). Precede it with a comment line of the same
   shape as the existing probe-evidence comment:
   `# Cargo.lock pins base64 = "^0.23" to 0.23.1 (no longer on
   # static.crates.io); bumped 2026.9.14 reinstalls fail offline. Holds
   # until upstream regenerates Cargo.lock against existing versions.`
3. Verify the `hold = [...]` block still parses as a valid TOML array
   (no trailing comma typos, quote balance, no missing closing bracket).

**Verify:** `grep -n "dev-util/mise" /var/db/repos/haven-overlay/ebuild-updater.toml` shows
exactly one match inside the `hold = [...]` array (line numbers will shift
by one after the new entry).

**Commit:** `ebuild-updater.toml: pin dev-util/mise (phantom-crate class; base64 ^0.23)`

---

## Task 2.1 — Regenerate metadata cache

**Goal:** `egencache` reflects the new hold entry so any cached status
output stops proposing the bump.

**Files:** none (cache-only)

**Steps:**
1. Run `sudo -n egencache --repo=haven-overlay --update`.

**Verify:** command exits 0; no error lines on stderr.

**Commit:** none (cache-only)

---

## Task 2.2 — Confirm `ebuild-updater status` no longer flags mise

**Goal:** running `status` shows `dev-util/mise` is no longer in any
"proposed bump" surface.

**Files:** none (read-only check)

**Steps:**
1. From `/var/db/repos/haven-overlay`, run:
   `ebuild-updater --config /etc/ebuild-updater/config.toml status --repo haven-overlay 2>&1 | tee /tmp/mise-status.txt`.
2. `grep -E "dev-util/mise" /tmp/mise-status.txt`; expect no proposed-bump
   line. If mise only appears as an installed/retention entry, that's fine.

**Verify:** grep returns either nothing or only non-bump context (e.g.
"held: dev-util/mise").

**Commit:** none

---

## Task 3.1 — `openspec validate` (this change)

**Goal:** the change's own artifacts pass strict validation.

**Files:** none

**Steps:**
1. `cd /var/db/repos/haven-overlay && openspec validate hold-mise-phantom-lockfile --strict`.

**Verify:** exit 0; JSON output `valid: true`.

**Commit:** none

---

## Task 3.2 — Verify next nightly run no longer hits the build failure

**Goal:** after the hold takes effect and one nightly cron has run, the
log file no longer contains the mise compile-phase failure.

**Files:** none

**Steps:**
1. Wait for the next `/etc/cron.daily/ebuild-updater` invocation (or run
   it manually: `sudo /etc/cron.daily/ebuild-updater`).
2. `awk '/mise/ && /failed/' /var/log/ebuild-updater-nightly.log | wc -l`
   → expect `0`.

**Verify:** count is 0.

**Commit:** none

---

## Task 3.3 — `openspec validate --all --strict`

**Goal:** no other in-flight change is invalidated by this one.

**Files:** none

**Steps:**
1. `cd /var/db/repos/haven-overlay && openspec validate --all --strict`.

**Verify:** exit 0.

**Commit:** none