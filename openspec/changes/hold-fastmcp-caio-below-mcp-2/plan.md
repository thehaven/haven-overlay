## Task 1.1 — Pin `fastmcp` and `caio` alongside `dev-python/mcp`

**Goal:** two new entries appear in `hold = [...]`, grouped with `dev-python/mcp` and a comment that points at the existing mcp hold for context.

**Files:**
- `/var/db/repos/haven-overlay/ebuild-updater.toml`

**Steps:**
1. Locate line 67 of `ebuild-updater.toml` (`"dev-python/mcp",`).
2. Immediately above that line, insert a comment that explains the
   relation:
   ```
   # Both declare <dev-python/mcp-2; mcp 2.x is masked system-wide
   # until the gateway package upgrades. Re-evaluate when fastmcp
   # lifts its ceiling (file an issue to remind).
   ```
3. Immediately below line 67 (the `"dev-python/mcp",` line), append the
   two new entries:
   ```
   "dev-python/fastmcp",
   "dev-python/caio",
   ```
4. Re-read the surrounding 10 lines to confirm the `hold = [...]` block
   is still valid TOML (no stray commas, balanced brackets, the
   comment lines start with `#`).

**Verify:** `grep -nE "fastmcp|caio|dev-python/mcp" /var/db/repos/haven-overlay/ebuild-updater.toml` shows
`mcp` on line 67, `fastmcp` on line 69 (or 70 if comment offset), `caio`
immediately after, and no spurious matches outside the `hold` array.

**Commit:** `ebuild-updater.toml: pin dev-python/fastmcp and dev-python/caio (mcp-2 ceiling)`

---

## Task 2.1 — Regenerate metadata cache

**Goal:** cached status reflects the new holds.

**Files:** none

**Steps:**
1. `sudo -n egencache --repo=haven-overlay --update`.

**Verify:** exit 0.

**Commit:** none

---

## Task 2.2 — Confirm `status` no longer flags either package

**Goal:** `ebuild-updater status` does not list either atom under a
"proposed bump" section.

**Files:** none

**Steps:**
1. From `/var/db/repos/haven-overlay`, run:
   `ebuild-updater --config /etc/ebuild-updater/config.toml status --repo haven-overlay 2>&1 | tee /tmp/status.txt`.
2. `grep -E "dev-python/(fastmcp|caio)" /tmp/status.txt`. Expect at most
   one of: a `held: dev-python/fastmcp` style line, or no match. Any
   line that proposes a bump is a regression.

**Verify:** zero proposed-bump lines for either atom.

**Commit:** none

---

## Task 3.1 — `openspec validate` (this change)

**Goal:** change artifacts pass strict validation.

**Files:** none

**Steps:**
1. `cd /var/db/repos/haven-overlay && openspec validate hold-fastmcp-caio-below-mcp-2 --strict`.

**Verify:** exit 0; JSON `valid: true`.

**Commit:** none

---

## Task 3.2 — Verify nightly run no longer surfaces the warning for these atoms

**Goal:** after one nightly cron cycle, the log file shows no
dep-graph-unsatisfiable entries attributable to fastmcp or caio.

**Files:** none

**Steps:**
1. Wait for the next `/etc/cron.daily/ebuild-updater` invocation (or run
   manually).
2. `awk '/fastmcp|caio/ && /dep-graph/' /var/log/ebuild-updater.log | wc -l`
   → expect `0`.

**Verify:** count is 0.

**Commit:** none

---

## Task 3.3 — `openspec validate --all --strict`

**Goal:** no other in-flight change is invalidated.

**Files:** none

**Steps:**
1. `cd /var/db/repos/haven-overlay && openspec validate --all --strict`.

**Verify:** exit 0.

**Commit:** none