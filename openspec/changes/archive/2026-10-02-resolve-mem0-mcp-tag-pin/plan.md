## Task 1.1 — Push the v0.1.0 tag to gitlab-ee

**Goal:** `refs/tags/v0.1.0` exists on gitlab-ee pointing at `55a23354` (or the agreed canonical commit).
**Files:** none (operator action in `/storage/home/haven/projects/.../mem0-mcp`).
**Steps:**
1. Decide the canonical lineage: gitlab `main` (`8dc163ca`) or local `main` (`229f17d9`); the tag target `55a23354` must be reachable on the pushed lineage.
2. `git push origin v0.1.0` (or re-create the tag on the canonical lineage and push it).
**Verify:** `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp.git refs/tags/v0.1.0` returns the commit
**Commit:** n/a

---

## Task 1.2 — Gate goes green for the pin

**Goal:** the versioned ebuild's pin resolves remotely (RED → GREEN).
**Files:** none.
**Steps:**
1. Re-run the tag probe as the portage user.
**Verify:** `ls-remote` shows `refs/tags/v0.1.0`
**Commit:** n/a

---

## Task 1.3 — Real fetch smoke test

**Goal:** `emerge --fetchonly` succeeds for the pinned ebuild.
**Files:** none.
**Steps:**
1. `sudo -u portage emerge --fetchonly =app-misc/mem0-mcp-0.1.0`
**Verify:** fetch completes; no "Unable to fetch" error
**Commit:** n/a

---

## Task 2.1 — Retire the versioned ebuild if the tag cannot be restored

**Goal:** the unfetchable 0.1.0 ebuild no longer blocks/confuses builds.
**Files:** `app-misc/mem0-mcp/mem0-mcp-0.1.0.ebuild` or `profiles/package.mask`
**Steps:**
1. Prefer `git rm app-misc/mem0-mcp/mem0-mcp-0.1.0.ebuild` (no users depend on the pin); alternatively mask with `# unfetchable EGIT_COMMIT=v0.1.0 (tag not on gitlab-ee) — 2026-08-13`.
**Verify:** `ls app-misc/mem0-mcp/` shows only remaining versions; or `grep mem0-mcp profiles/package.mask`
**Commit:** `app-misc/mem0-mcp: retire 0.1.0 ebuild (tag not on gitlab-ee)`

---

## Task 2.2 — Regenerate metadata cache

**Goal:** local portage cache matches the tree.
**Files:** none.
**Steps:**
1. `sudo -n egencache --repo=haven-overlay --update`
**Verify:** command completes without error
**Commit:** n/a

---

## Task 3.1 — Full gate run

**Goal:** end-to-end confirmation.
**Files:** none.
**Steps:**
1. `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh`
**Verify:** exit 0 (mem0-mcp URIs green; any residual failures are unrelated/masked)
**Commit:** n/a

---

## Task 3.2 — Retirement sanity check

**Goal:** 0.1.0 gone/masked, 9999 still installable.
**Files:** none.
**Steps:**
1. `emerge --pretend =app-misc/mem0-mcp-0.1.0` → blocked/masked; `emerge --pretend app-misc/mem0-mcp` → 9999 resolves.
**Verify:** both behaviours observed
**Commit:** n/a
