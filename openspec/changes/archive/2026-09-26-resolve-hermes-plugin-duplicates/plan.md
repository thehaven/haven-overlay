## Task 1.1 — Enumerate the cluster via `duplicates --json`

**Goal:** capture the complete list of `hermes-plugin-*` siblings + the
canonical `hermes-plugin-browser` so the `atoms` array in Task 2.1 is
authoritative.

**Files:** none (read-only enumeration)

**Steps:**
1. `cd /var/db/repos/haven-overlay && ebuild-updater --config /etc/ebuild-updater/config.toml duplicates --json > /tmp/dupes.json`.
2. `jq -r '.unapproved[] | select(.atoms[] | contains("hermes-plugin")) | .atoms[]' /tmp/dupes.json > /tmp/hermes-cluster.txt`.
3. Confirm `/tmp/hermes-cluster.txt` contains the canonical
   `hermes-plugin-browser` plus all 15 siblings (16 lines total).

**Verify:** `wc -l /tmp/hermes-cluster.txt` = 16;
`grep -c "hermes-plugin-browser" /tmp/hermes-cluster.txt` = 1.

**Commit:** none (output file in /tmp)

---

## Task 2.1 — Append the `[[duplicates.allow]]` block

**Goal:** one `[[duplicates.allow]]` entry exists in
`/etc/ebuild-updater/config.toml` covering the entire 16-atom cluster,
with a `reason` of at least 10 characters and the correct
`upstream` guard.

**Files:**
- `/etc/ebuild-updater/config.toml`

**Steps:**
1. Open `/etc/ebuild-updater/config.toml`. If a `[duplicates]` table is
   not yet present, copy it verbatim from
   `config.toml.example:168-170` (lines `policy = "hold"` and
   `check_gentoo_shadow = true`).
2. After the `[duplicates]` table, append:
   ```toml
   [[duplicates.allow]]
   atoms = [
       "app-misc/hermes-plugin-browser",
       "app-misc/hermes-plugin-context-engine",
       "app-misc/hermes-plugin-dashboard",
       "app-misc/hermes-plugin-disk-cleanup",
       "app-misc/hermes-plugin-example-dashboard",
       "app-misc/hermes-plugin-google-meet",
       "app-misc/hermes-plugin-hermes-achievements",
       "app-misc/hermes-plugin-image-gen",
       "app-misc/hermes-plugin-kanban",
       "app-misc/hermes-plugin-memory",
       "app-misc/hermes-plugin-model-providers",
       "app-misc/hermes-plugin-observability",
       "app-misc/hermes-plugin-platforms",
       "app-misc/hermes-plugin-spotify",
       "app-misc/hermes-plugin-video-gen",
       "app-misc/hermes-plugin-web",
   ]
   upstream = "github:NousResearch/hermes-agent"
   reason = "monorepo component split; distinct build targets, shared NousResearch/hermes-agent upstream"
   ```
   Do NOT abbreviate with `...`; every atom is required for the
   detector to match.
3. Re-parse the file with `python3 -c "import tomllib; tomllib.load(open('/etc/ebuild-updater/config.toml','rb'))"` to catch any TOML syntax error before the duplicate detector reloads.

**Verify:** `grep -A20 "^\[\[duplicates.allow\]\]" /etc/ebuild-updater/config.toml` shows the
full 16-atom block; `python3 -c "import tomllib; tomllib.load(open('/etc/ebuild-updater/config.toml','rb'))"` exits 0.

**Commit:** `ebuild-updater: allow hermes-plugin-* duplicate cluster (NousResearch/hermes-agent monorepo split)`

---

## Task 3.1 — `duplicates --json` no longer lists the cluster

**Goal:** running the duplicate detector post-change does not surface the
`hermes-plugin-*` cluster as unapproved.

**Files:** none

**Steps:**
1. `cd /var/db/repos/haven-overlay && ebuild-updater --config /etc/ebuild-updater/config.toml duplicates --json --repo haven-overlay > /tmp/dupes.json`.
2. `jq -r '.unapproved[] | select(.atoms[] | contains("hermes-plugin")) | .atoms[]' /tmp/dupes.json | wc -l` → expect 0.

**Verify:** count is 0.

**Commit:** none

---

## Task 3.2 — Nightly run no longer emits the warning

**Goal:** after one nightly cron cycle, the log file has zero
`hermes-plugin-* duplicate-upstream hold` warnings.

**Files:** none

**Steps:**
1. Wait for (or manually invoke) the next nightly cron.
2. `grep -c "hermes-plugin-.*duplicate-upstream hold" /var/log/ebuild-updater.log` → expect 0.

**Verify:** count is 0.

**Commit:** none

---

## Task 3.3 — `openspec validate` (this change)

**Goal:** change artifacts pass strict validation.

**Files:** none

**Steps:**
1. `cd /var/db/repos/haven-overlay && openspec validate resolve-hermes-plugin-duplicates --strict`.

**Verify:** exit 0.

**Commit:** none

---

## Task 3.4 — `openspec validate --all --strict`

**Goal:** no other in-flight change is invalidated.

**Files:** none

**Steps:**
1. `cd /var/db/repos/haven-overlay && openspec validate --all --strict`.

**Verify:** exit 0.

**Commit:** none