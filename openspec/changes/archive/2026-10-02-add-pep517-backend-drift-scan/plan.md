## Task 1.1 — Reference audit script: port from /tmp to scripts/

**Goal**: Move the working audit from `/tmp/opencode/pep517-audit/audit.py`
into the overlay at `scripts/audit_pep517_backend_drift.py` so it ships
with the repo and is reusable by `ebuild-updater cleanup scan` (next
task).
**Files**: `scripts/audit_pep517_backend_drift.py` (new)
**Steps**:
1. Copy `/tmp/opencode/pep517-audit/audit.py` to the repo path. Strip
   the ad-hoc test harness (`if __name__ == '__main__'`); keep the
   `BACKEND_MAP`, `extract_pyproject`, `parse_backend`,
   `ebuild_pep517`, `find_distfiles`, `parse_ebuild_path`, and a
   `main()` that scans the overlay passed via `--overlay` (default
   `/var/db/repos/haven-overlay`).
2. Add `--json` output mode (machine-readable for the scanner).
3. Add a quick smoke test on this session's 47 mismatches: running
   the script post-port should reproduce the 47-mismatch count.
**Verify**: `python3 scripts/audit_pep517_backend_drift.py
--overlay /var/db/repos/haven-overlay | grep MISMATCHES` reports
`MISMATCHES: 0` after the 11 fix commits (the 11 fixes earlier in
this session should have eliminated every detected mismatch for the
ebuilds whose tarballs are cached).
**Commit**: `scripts: add audit_pep517_backend_drift.py (port from
session audit)`

---

## Task 1.2 — Promote audit to ebuild-updater cleanup scan

**Goal**: ebuild-updater's `cleanup scan` emits
`[wrong-pep517-backend]` for every ebuild whose
`DISTUTILS_USE_PEP517` doesn't match upstream `pyproject.toml`
build-backend.
**Files**: ebuild-updater source (separate repo, openspec proposal
filed there); this task is the verification gate.
**Steps**:
1. File the openspec change against
   `gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater` describing the
   new category (this doc is the design).
2. Implement in ebuild-updater: add `wrong-pep517-backend` to the
   scanner category list. Internally, call
   `scripts/audit_pep517_backend_drift.py --json` and translate each
   entry to `[wrong-pep517-backend] <ebuild-path>: current=<X>
   upstream=<Y> should_be=<Z>`.
3. Wire the same scan into `cleanup run --repair`: rewrite the
   `DISTUTILS_USE_PEP517=` line to the canonical value when the
   `--repair` flag is set. Audit script already enumerates the change;
   the scanner just calls the same regex.
4. Verify: `ebuild-updater cleanup scan` reports 0 entries on the
   current overlay state (after the 11 fix commits in this session).
5. Verify: introduce a synthetic mismatch (e.g. temporarily edit
   `dev-python/stripe/stripe-15.6.1.ebuild` to set
   `DISTUTILS_USE_PEP517=setuptools`), run the scanner, confirm
   `[wrong-pep517-backend]` is reported. Revert.
**Verify**: `ebuild-updater cleanup scan` JSON output contains a
`wrong-pep517-backend` category key; running it after a synthetic
mismatch yields the expected single entry.
**Commit**: (in ebuild-updater repo, separate PR)

---

## Task 1.3 — Regression test: pytest for the audit

**Goal**: `pytest scripts/tests/test_pep517_backend_drift.py` passes
on every overlay commit; failures block CI / pre-commit.
**Files**: `scripts/tests/test_pep517_backend_drift.py` (new)
**Steps**:
1. Write a test that runs the audit against a tiny fixture overlay
   (e.g. one fake ebuild with `DISTUTILS_USE_PEP517=setuptools` and
   a tarball with `build-backend = flit_core.buildapi`) and asserts
   `wrong-pep517-backend` is emitted.
2. Add a positive test: same fixture but matching backends, assert
   no entry.
3. Add a test that simulates the 11 packages from this session and
   confirms the audit reproduces 0 mismatches after the per-package
   fixes.
**Verify**: `pytest scripts/tests/test_pep517_backend_drift.py -v`
runs all three tests green.
**Commit**: `test(scripts): add pep517 backend drift regression
fixture`

---

## Task 1.4 — Documentation: AGENTS.md verified gotcha

**Goal**: future agents see this defect class in the overlay's
operating guide and run the audit before declaring an ebuild
PEP517 fix complete.
**Files**: `AGENTS.md`
**Steps**:
1. Add a new entry under "Verified gotchas (overlay-specific)":
   - Title: `DISTUTILS_USE_PEP517 backend drift after upstream
     retool`
   - Symptom: `DISTUTILS_UPSTREAM_PEP517 does not match
     pyproject.toml!` die in src_compile.
   - Cause: upstream changed build-backend between versions;
     ebuild-updater bump propagates the stale value.
   - Fix: change `DISTUTILS_USE_PEP517` to match upstream;
     eclass auto-adds the right BDEPEND. **Verify per-version,
     never assume siblings share a backend** (face-26.0.0 vs
     26.0.1 was the trigger case).
   - Detection: `scripts/audit_pep517_backend_drift.py` (added in
     Task 1.1) and `ebuild-updater cleanup scan` (Task 1.2).
**Verify**: `git grep DISTUTILS_USE_PEP517 AGENTS.md` matches the
new entry; `make test` (if defined) still passes.
**Commit**: `haven-overlay: document DISTUTILS_USE_PEP517 backend
drift gotcha`

---

## Task 1.5 — Documentation: gentoo-ebuild skill refinement

**Goal**: the gentoo-ebuild skill's precommit-gate item 4
(`PEP517 match`) gets an executable command and a sibling-version
anti-pattern rule, so future ebuild authors run the check.
**Files**: `/storage/home/haven/.config/opencode/skills/gentoo-ebuild/SKILL.md`
(plus a backport to
`~/projects/personal/salman-skills/skills/gentoo-ebuild/SKILL.md` if
that's the canonical source).
**Steps**:
1. Add to the precommit-gate item 4 a concrete command:
   ```
   tar -xzf /usr/portage-distfiles/<pkg>-<ver>.tar.gz \
       -O <pkg>-<ver>/pyproject.toml 2>/dev/null \
       | grep build-backend
   ```
   The build-backend must match the skill's mapping table.
2. Add a sibling-version rule in §11 Common Mistakes: "When a
   package has multiple ebuilds at different versions, verify each
   tarball independently. Adjacent versions can use different
   build backends (face-26.0.0 → setuptools; face-26.0.1 → flit;
   phx-class-registry 5.1.1 → poetry; 5.2.1/5.2.2 → hatchling)."
3. Bump the maintenance `Last updated:` line in the skill.
**Verify**: opencode restarts; the gentoo-ebuild skill loads with
the new content; a smoke load via `skill gentoo-ebuild` succeeds.
**Commit**: (in salman-skills repo, separate PR; both paths
mirrored per personal-standards skill protocol)

---

## Task 1.6 — Verification: re-run audit on overlay post-fixes

**Goal**: confirm the 11 per-package fix commits in this session
actually eliminated every cached mismatch.
**Files**: none (verification only)
**Steps**:
1. After Task 1.1 lands the audit script in `scripts/`, run
   `python3 scripts/audit_pep517_backend_drift.py --overlay
   /var/db/repos/haven-overlay`.
2. Expected: `MISMATCHES: 0` for the 47 ebuilds fixed in this
   session whose tarballs are cached. (Tarballs not in
   `/usr/portage-distfiles/` are skipped; that's fine for this
   gate.)
3. Note any remaining mismatches in the change report.
**Verify**: the script's stdout line "MISMATCHES: 0".
**Commit**: (no commit — verification only)