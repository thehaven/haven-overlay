# Implementation Plan - add-overlay-ci-gate
## Existing context

Read these, in this order, before touching anything. Do not re-derive them.

1. `proposal.md` - the six decisions and the job table. The pipeline **never**
   commits, pushes, mutates the tree, or gates on `metadata/md5-cache/`.
2. `specs/overlay-ci-gate/spec.md` - the seven requirements. Each task below names
   the exact requirement it fulfils; the names must match the spec verbatim.
3. `preflight.md` - the reachability results, the recorded test-suite baseline and the
   GATE. Do not re-run the probes that already passed; re-run only the ones the
   preflight left as a task.

Facts you need and must not re-derive:

- The GitLab remote **is** reachable from this host. `git ls-remote origin HEAD`
  exits 0 and returns `e1b5e9cc3dcdc17f48c91c84f9de11d646484acb`. Both the SSH fetch
  URL and the HTTPS push URL resolve. Earlier notes in this session claiming the
  remote was unreachable are obsolete.
- The GitLab CI-lint API at `https://gitlab-ee.thehavennet.org.uk/api/v4/ci/lint`
  returns **404 without a token**, so the pipeline cannot be linted against the
  GitLab project from this host. Local YAML validation (`python3 -c "import yaml;
  yaml.safe_load(...)"`, PyYAML 6.0.3) is the available instrument. A task may
  record "CI lint not performed: API requires a token" as an honest limitation.
- `pkgcheck` 0.10.39 is present at `/usr/sbin/pkgcheck` (as is `portageq`).
  `pkgcheck scan` accepts positional TARGETs to limit the scan to specific packages,
  and `--exit ITEM` controls which checks trigger a non-zero exit. This is the
  read-only instrument for the digest gate; `ebuild <file> manifest` is **not**
  suitable because it writes the `Manifest` file.
- `pkgcheck` 0.10.39 **crashes on this host for `dev-python` packages** under Python
  3.14.7: `TypeError: 'ContainmentMatch' object is not iterable` at
  `pkgcheck/checks/python.py:366`. This is a pkgcheck-vs-Python-3.14 bug, not an
  overlay defect. Non-Python packages scan cleanly. The pipeline must therefore
  treat a `pkgcheck` **crash** as "not checked", not as "clean".
- `pkgcheck` 0.10.39 already reports `UnknownRestrict: unknown
  RESTRICT="network-sandbox"` on the overlay's own ebuilds - it does not know
  portage's `network-sandbox` feature, which `AGENTS.md` documents as correct
  practice. Together with `VariableOrderWrong`, `WhitespaceFound` and
  `RedundantVersion`, this is the **pre-existing repo-wide finding baseline**. The
  gate must therefore compare findings **for the changed ebuilds only**, and must
  never gate on a repo-wide finding count.
- `egencache --help` has **no `--dry-run`**; it only offers `--update` variants. It
  mutates `metadata/md5-cache/` and is therefore only ever run inside a scratch copy,
  and its result is reported, never gated.
- The overlay test suite takes **more than three minutes** on this host and needs
  network access (`scripts/tests/test_src_uri_fetchable.py` is network-dependent).
  The pipeline job needs network and a generous timeout. The recorded baseline
  (pass/fail counts and the names of any pre-existing failures) is in
  `preflight.md`; the pipeline must treat those as pre-existing.
- `scripts/tests/` holds 11 test files. `pytest scripts/tests/` is the invocation.
- The overlay has no `.gitlab-ci.yml`, no `.github/` and no active `.git/hooks/`.
  This change adds the first pipeline.
- There is no CI in this repository, so **no task may claim CI evidence** until a
  push has actually run. Record "not run: no pipeline exists yet" honestly.
- Housekeeping: the working tree carries unrelated pre-existing `metadata/md5-cache/`
  churn from an earlier session. Leave it unstaged. Commit only the files a task
  names.

### 0. Preconditions and baseline

## Task 0.1 - Record the baseline state of the overlay before any pipeline exists

**Goal:** Record the baseline state of the overlay before any pipeline exists. Satisfies the requirement "A pipeline runs on every push to master and every merge request".

**Files:**
- `openspec/changes/add-overlay-ci-gate/preflight.md`

**Steps:**
1. Record the changed-ebuild derivation command and confirm it returns a list of paths relative to the repo root.
2. Record the ebuild count (3288) and category count (52) so a later full-tree regression is detectable.

**Verify:** `cd /var/db/repos/haven-overlay && git rev-parse --abbrev-ref HEAD && git rev-parse HEAD && ls .gitlab-ci.yml`

**Commit:** `ci/overlay: record the baseline state of the overlay before any pipeline exists` (conventional-commit style; only the files named above are staged)

## Task 0.2 - Confirm the working tree is clean of unintended changes before starting

**Goal:** Confirm the working tree is clean of unintended changes before starting. Satisfies the requirement "The pipeline never writes to the repository".

**Files:**
- `openspec/changes/add-overlay-ci-gate/preflight.md`

**Steps:**
1. Confirm every metadata/md5-cache/ entry is pre-existing churn and is left unstaged.
2. Confirm no ebuild is modified by this change.

**Verify:** `cd /var/db/repos/haven-overlay && git status --short`

**Commit:** `ci/overlay: confirm the working tree is clean of unintended changes before starting` (conventional-commit style; only the files named above are staged)

## Task 0.3 - Confirm the test-suite baseline recorded in preflight.md is the current baseline

**Goal:** Confirm the test-suite baseline recorded in preflight.md is the current baseline. Satisfies the requirement "The overlay test suite gates the pipeline".

**Files:**
- `openspec/changes/add-overlay-ci-gate/preflight.md`

**Steps:**
1. Compare the pass/fail counts with the preflight baseline.
2. If they differ, record the difference and why before proceeding; a moving baseline makes the gate meaningless.

**Verify:** `cd /var/db/repos/haven-overlay && PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python3 -m pytest scripts/tests/ -q --tb=line`

**Commit:** `ci/overlay: confirm the test-suite baseline recorded in preflight.md is the current baseline` (conventional-commit style; only the files named above are staged)

### 1. RED - the pipeline specification is executable and read-only

## Task 1.1 - Write a test that the pipeline definition is valid YAML with the expected job set

**Goal:** Write a test that the pipeline definition is valid YAML with the expected job set. Satisfies the requirement "A pipeline runs on every push to master and every merge request".

**Files:**
- `scripts/tests/test_overlay_ci_gate.py`

**Steps:**
1. Assert the trigger rules reference master and that an mr event is covered.
2. Assert the file is absent before this change lands, so the test fails for the right reason.

**Verify:** `cd /var/db/repos/haven-overlay && PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python3 -m pytest scripts/tests/test_overlay_ci_gate.py -q`

**Commit:** `ci/overlay: write a test that the pipeline definition is valid yaml with the expected job set` (conventional-commit style; only the files named above are staged)

## Task 1.2 - Write a test that no pipeline job writes to the repository

**Goal:** Write a test that no pipeline job writes to the repository. Satisfies the requirement "The pipeline never writes to the repository".

**Files:**
- `scripts/tests/test_overlay_ci_gate.py`

**Steps:**
1. Assert any ebuild or egencache invocation is confined to a scratch copy path.
2. Assert the pipeline declares no gitlab-ci token or other write credential.

**Verify:** `cd /var/db/repos/haven-overlay && PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python3 -m pytest scripts/tests/test_overlay_ci_gate.py -q`

**Commit:** `ci/overlay: write a test that no pipeline job writes to the repository` (conventional-commit style; only the files named above are staged)

## Task 1.3 - Write a test that the digest gate targets only the changed ebuilds

**Goal:** Write a test that the digest gate targets only the changed ebuilds. Satisfies the requirement "Changed ebuilds are validated against their recorded digests".

**Files:**
- `scripts/tests/test_overlay_ci_gate.py`

**Steps:**
1. Assert the job does not pass the whole tree as a target.
2. Assert an empty changed set does not fail the job.

**Verify:** `cd /var/db/repos/haven-overlay && PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python3 -m pytest scripts/tests/test_overlay_ci_gate.py -q`

**Commit:** `ci/overlay: write a test that the digest gate targets only the changed ebuilds` (conventional-commit style; only the files named above are staged)

### 2. GREEN - the GitLab CI pipeline definition

## Task 2.1 - Add .gitlab-ci.yml with the trigger rules and the job skeleton

**Goal:** Add .gitlab-ci.yml with the trigger rules and the job skeleton. Satisfies the requirement "A pipeline runs on every push to master and every merge request".

**Files:**
- `.gitlab-ci.yml`

**Steps:**
1. Give every job a script, an artifacts section where relevant, and a timeout; do not add a job that writes.
2. Confirm no job in the file contains git commit, git push, ebuild manifest or egencache.

**Verify:** `cd /var/db/repos/haven-overlay && python3 -c "import yaml,sys; d=yaml.safe_load(open('.gitlab-ci.yml')); print(sorted(d['stages']))"`

**Commit:** `ci/overlay: add .gitlab-ci.yml with the trigger rules and the job skeleton` (conventional-commit style; only the files named above are staged)

## Task 2.2 - Add the read-only job that derives the changed ebuild set

**Goal:** Add the read-only job that derives the changed ebuild set. Satisfies the requirement "The pipeline never writes to the repository".

**Files:**
- `.gitlab-ci.yml`

**Steps:**
1. Write the list to a file in the job artifacts so later jobs consume the same set.
2. Assert the derivation handles an empty set without failing the job.

**Verify:** `cd /var/db/repos/haven-overlay && git diff --name-only --diff-filter=ACMR HEAD~1 HEAD -- '*.ebuild'`

**Commit:** `ci/overlay: add the read-only job that derives the changed ebuild set` (conventional-commit style; only the files named above are staged)

## Task 2.3 - Add the digest gate job scoped to the changed ebuilds

**Goal:** Add the digest gate job scoped to the changed ebuilds. Satisfies the requirement "Changed ebuilds are validated against their recorded digests".

**Files:**
- `.gitlab-ci.yml`

**Steps:**
1. Add a fallback that classifies a pkgcheck crash as not-checked and reports it, never as clean.
2. Confirm the job reads only the changed-ebuild list and never writes a Manifest.

**Verify:** `cd /var/db/repos/haven-overlay && python3 -c "import yaml; d=yaml.safe_load(open('.gitlab-ci.yml')); print('digest job present:', 'manifest-verify' in d)"`

**Commit:** `ci/overlay: add the digest gate job scoped to the changed ebuilds` (conventional-commit style; only the files named above are staged)

## Task 2.4 - Add the overlay test-suite job that gates the pipeline

**Goal:** Add the overlay test-suite job that gates the pipeline. Satisfies the requirement "The overlay test suite gates the pipeline".

**Files:**
- `.gitlab-ci.yml`

**Steps:**
1. Set a timeout that exceeds the recorded suite runtime and declare network access.
2. Mark the recorded pre-existing failures as allowed for now, by exact test id, so a NEW failure still fails the job.

**Verify:** `cd /var/db/repos/haven-overlay && python3 -c "import yaml; d=yaml.safe_load(open('.gitlab-ci.yml')); print('tests job present:', 'overlay-tests' in d)"`

**Commit:** `ci/overlay: add the overlay test-suite job that gates the pipeline` (conventional-commit style; only the files named above are staged)

## Task 2.5 - Add the verify-script job that runs the scripts/verify-*.sh family

**Goal:** Add the verify-script job that runs the scripts/verify-*.sh family. Satisfies the requirement "The verify script family gates the pipeline".

**Files:**
- `.gitlab-ci.yml`

**Steps:**
1. Fail the job when a script reports a finding.
2. Confirm no script in the job writes to the repository.

**Verify:** `cd /var/db/repos/haven-overlay && python3 -c "import yaml; d=yaml.safe_load(open('.gitlab-ci.yml')); print('verify job present:', 'verify-scripts' in d)"`

**Commit:** `ci/overlay: add the verify-script job that runs the scripts/verify-*.sh family` (conventional-commit style; only the files named above are staged)

## Task 2.6 - Add the advisory blocklist job, conditional on the sibling change landing

**Goal:** Add the advisory blocklist job, conditional on the sibling change landing. Satisfies the requirement "The advisory blocklist gate runs once the sibling change lands".

**Files:**
- `.gitlab-ci.yml`

**Steps:**
1. Make the job conditional or allow-fail so it is a no-op until the sibling change lands, and say so in a comment.
2. Confirm the job never edits the advisory feed or the block list.

**Verify:** `cd /var/db/repos/haven-overlay && python3 -c "import yaml; d=yaml.safe_load(open('.gitlab-ci.yml')); print('blocklist job present:', 'blocklist-gate' in d)"`

**Commit:** `ci/overlay: add the advisory blocklist job, conditional on the sibling change landing` (conventional-commit style; only the files named above are staged)

## Task 2.7 - Add the metadata-cache reporting job that never gates

**Goal:** Add the metadata-cache reporting job that never gates. Satisfies the requirement "The metadata cache is reported and never gates".

**Files:**
- `.gitlab-ci.yml`

**Steps:**
1. Mark the job allow_failure so it never gates the pipeline.
2. Assert the job never writes metadata/md5-cache/ in the repository working tree.

**Verify:** `cd /var/db/repos/haven-overlay && python3 -c "import yaml; d=yaml.safe_load(open('.gitlab-ci.yml')); print('cache job present:', 'md5-cache-report' in d)"`

**Commit:** `ci/overlay: add the metadata-cache reporting job that never gates` (conventional-commit style; only the files named above are staged)

### 3. GREEN - the local gate runner

## Task 3.1 - Add the local gate runner script that the pipeline calls

**Goal:** Add the local gate runner script that the pipeline calls. Satisfies the requirement "Changed ebuilds are validated against their recorded digests".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Classify a pkgcheck crash as not-checked and exit non-zero, never silently pass.
2. Make the script read-only: no ebuild manifest, no egencache, no git write.

**Verify:** `cd /var/db/repos/haven-overlay && sh -n scripts/verify-overlay-ci-gate.sh`

**Commit:** `ci/overlay: add the local gate runner script that the pipeline calls` (conventional-commit style; only the files named above are staged)

## Task 3.2 - Add the local runner mode that executes the overlay test suite

**Goal:** Add the local runner mode that executes the overlay test suite. Satisfies the requirement "The overlay test suite gates the pipeline".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Add a mode that compares the outcome against the recorded baseline and reports NEW failures separately.
2. Ensure the mode exits non-zero on a new failure and zero on a baseline-only outcome.

**Verify:** `cd /var/db/repos/haven-overlay && sh -n scripts/verify-overlay-ci-gate.sh`

**Commit:** `ci/overlay: add the local runner mode that executes the overlay test suite` (conventional-commit style; only the files named above are staged)

## Task 3.3 - Add the local runner mode that executes the verify-script family

**Goal:** Add the local runner mode that executes the verify-script family. Satisfies the requirement "The verify script family gates the pipeline".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Record each script's name and status in the output.
2. Exit non-zero when any script reports a finding.

**Verify:** `cd /var/db/repos/haven-overlay && sh -n scripts/verify-overlay-ci-gate.sh`

**Commit:** `ci/overlay: add the local runner mode that executes the verify-script family` (conventional-commit style; only the files named above are staged)

## Task 3.4 - Add the local runner mode for the advisory blocklist gate

**Goal:** Add the local runner mode for the advisory blocklist gate. Satisfies the requirement "The advisory blocklist gate runs once the sibling change lands".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Keep the mode read-only: it must not regenerate the mask or edit the feed.
2. Exit non-zero on drift when the script is present.

**Verify:** `cd /var/db/repos/haven-overlay && sh -n scripts/verify-overlay-ci-gate.sh`

**Commit:** `ci/overlay: add the local runner mode for the advisory blocklist gate` (conventional-commit style; only the files named above are staged)

## Task 3.5 - Add the local runner mode that reports the metadata cache without gating

**Goal:** Add the local runner mode that reports the metadata cache without gating. Satisfies the requirement "The metadata cache is reported and never gates".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Report the resulting difference as information only.
2. Assert the repository's metadata/md5-cache/ is byte-identical before and after the mode runs.

**Verify:** `cd /var/db/repos/haven-overlay && sh -n scripts/verify-overlay-ci-gate.sh`

**Commit:** `ci/overlay: add the local runner mode that reports the metadata cache without gating` (conventional-commit style; only the files named above are staged)

## Task 3.6 - Prove the local runner never mutates the repository

**Goal:** Prove the local runner never mutates the repository. Satisfies the requirement "The pipeline never writes to the repository".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Re-run every mode of the script.
2. Assert both the checksum and git status are unchanged afterwards.

**Verify:** `cd /var/db/repos/haven-overlay && git status --short`

**Commit:** `ci/overlay: prove the local runner never mutates the repository` (conventional-commit style; only the files named above are staged)

### 4. Documentation and conventions

## Task 4.1 - Document the pipeline in the overlay cheatsheet

**Goal:** Document the pipeline in the overlay cheatsheet. Satisfies the requirement "A pipeline runs on every push to master and every merge request".

**Files:**
- `docs/gentoo-ebuild-cheatsheet.md`

**Steps:**
1. Record that the pipeline never pushes and never gates on metadata/md5-cache/.
2. Record how to run the same gates locally via scripts/verify-overlay-ci-gate.sh.

**Verify:** `cd /var/db/repos/haven-overlay && grep -c verify-overlay-ci-gate.sh docs/gentoo-ebuild-cheatsheet.md`

**Commit:** `ci/overlay: document the pipeline in the overlay cheatsheet` (conventional-commit style; only the files named above are staged)

## Task 4.2 - Document the known pkgcheck baseline and the crash in the cheatsheet

**Goal:** Document the known pkgcheck baseline and the crash in the cheatsheet. Satisfies the requirement "Changed ebuilds are validated against their recorded digests".

**Files:**
- `docs/gentoo-ebuild-cheatsheet.md`

**Steps:**
1. Record that pkgcheck crashes for dev-python packages under Python 3.14 and that a crash is not-checked.
2. Record that the gate is scoped to changed ebuilds and never to the repo-wide finding count.

**Verify:** `cd /var/db/repos/haven-overlay && grep -c network-sandbox docs/gentoo-ebuild-cheatsheet.md`

**Commit:** `ci/overlay: document the known pkgcheck baseline and the crash in the cheatsheet` (conventional-commit style; only the files named above are staged)

## Task 4.3 - Record the metadata-cache convention in the cheatsheet

**Goal:** Record the metadata-cache convention in the cheatsheet. Satisfies the requirement "The metadata cache is reported and never gates".

**Files:**
- `docs/gentoo-ebuild-cheatsheet.md`

**Steps:**
1. State that egencache has no dry-run mode and is only ever run in a scratch copy.
2. Cross-reference the AGENTS.md rule rather than duplicating it.

**Verify:** `cd /var/db/repos/haven-overlay && grep -c md5-cache docs/gentoo-ebuild-cheatsheet.md`

**Commit:** `ci/overlay: record the metadata-cache convention in the cheatsheet` (conventional-commit style; only the files named above are staged)

### 5. Live validation

## Task 5.1 - Validate the pipeline YAML locally and record that GitLab lint was not possible

**Goal:** Validate the pipeline YAML locally and record that GitLab lint was not possible. Satisfies the requirement "A pipeline runs on every push to master and every merge request".

**Files:**
- `.gitlab-ci.yml`

**Steps:**
1. Confirm the trigger rules reference master and cover merge requests.
2. Record that the GitLab CI-lint API returns 404 without a token, so project-side linting was not performed.

**Verify:** `cd /var/db/repos/haven-overlay && python3 -c "import yaml; d=yaml.safe_load(open('.gitlab-ci.yml')); print(sorted(d))"`

**Commit:** `ci/overlay: validate the pipeline yaml locally and record that gitlab lint was not possible` (conventional-commit style; only the files named above are staged)

## Task 5.2 - Run the digest gate against a real changed ebuild and observe the expected pkgcheck behaviour

**Goal:** Run the digest gate against a real changed ebuild and observe the expected pkgcheck behaviour. Satisfies the requirement "Changed ebuilds are validated against their recorded digests".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Run the digest mode and record the pkgcheck output, including any crash and its classification.
2. Confirm the job would not have reported clean if pkgcheck had crashed.

**Verify:** `cd /var/db/repos/haven-overlay && sh scripts/verify-overlay-ci-gate.sh --help`

**Commit:** `ci/overlay: run the digest gate against a real changed ebuild and observe the expected pkgcheck behaviour` (conventional-commit style; only the files named above are staged)

## Task 5.3 - Run the test-suite mode and confirm it distinguishes the baseline from a new failure

**Goal:** Run the test-suite mode and confirm it distinguishes the baseline from a new failure. Satisfies the requirement "The overlay test suite gates the pipeline".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Confirm the recorded pre-existing failures are reported as baseline, not as new.
2. Confirm the mode exits non-zero when a deliberate extra failure is introduced, then remove that failure.

**Verify:** `cd /var/db/repos/haven-overlay && PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python3 -m pytest scripts/tests/ -q --tb=line`

**Commit:** `ci/overlay: run the test-suite mode and confirm it distinguishes the baseline from a new failure` (conventional-commit style; only the files named above are staged)

## Task 5.4 - Run the verify-script mode and confirm each script's status is reported

**Goal:** Run the verify-script mode and confirm each script's status is reported. Satisfies the requirement "The verify script family gates the pipeline".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Confirm every script in the family is attempted and its status recorded.
2. Confirm the mode exits non-zero when a script reports a finding.

**Verify:** `cd /var/db/repos/haven-overlay && sh scripts/verify-overlay-ci-gate.sh --help`

**Commit:** `ci/overlay: run the verify-script mode and confirm each script's status is reported` (conventional-commit style; only the files named above are staged)

## Task 5.5 - Run the metadata-cache mode and confirm the repository is byte-identical afterwards

**Goal:** Run the metadata-cache mode and confirm the repository is byte-identical afterwards. Satisfies the requirement "The metadata cache is reported and never gates".

**Files:**
- `scripts/verify-overlay-ci-gate.sh`

**Steps:**
1. Run the metadata-cache mode.
2. Assert the checksum and git status are unchanged and the mode reports its result without gating.

**Verify:** `cd /var/db/repos/haven-overlay && git status --short`

**Commit:** `ci/overlay: run the metadata-cache mode and confirm the repository is byte-identical afterwards` (conventional-commit style; only the files named above are staged)

### 6. Regression sweep

## Task 6.1 - Run the full overlay test suite and record the outcome against the baseline

**Goal:** Run the full overlay test suite and record the outcome against the baseline. Satisfies the requirement "The overlay test suite gates the pipeline".

**Files:**
- `scripts/tests/`

**Steps:**
1. Compare the result with the preflight baseline and the task 0.3 re-run.
2. Record any new failure by name and fix it; never silence, skip or xfail a test.

**Verify:** `cd /var/db/repos/haven-overlay && PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python3 -m pytest scripts/tests/ -q --tb=line`

**Commit:** `ci/overlay: run the full overlay test suite and record the outcome against the baseline` (conventional-commit style; only the files named above are staged)

## Task 6.2 - Prove the final diff contains no write path and no metadata cache churn

**Goal:** Prove the final diff contains no write path and no metadata cache churn. Satisfies the requirement "The pipeline never writes to the repository".

**Files:**
- `openspec/changes/add-overlay-ci-gate/`

**Steps:**
1. Confirm metadata/md5-cache/ appears nowhere in the staged or unstaged set attributable to this change.
2. Confirm no ebuild was modified.

**Verify:** `cd /var/db/repos/haven-overlay && git diff --name-only HEAD~1 HEAD`

**Commit:** `ci/overlay: prove the final diff contains no write path and no metadata cache churn` (conventional-commit style; only the files named above are staged)

## Task 6.3 - Record that no CI evidence exists yet and that the first push is the real test

**Goal:** Record that no CI evidence exists yet and that the first push is the real test. Satisfies the requirement "The metadata cache is reported and never gates".

**Files:**
- `openspec/changes/add-overlay-ci-gate/plan.md`

**Steps:**
1. Record in the plan that the first push to master is where the pipeline is proven, and that a failed job there is expected to surface pre-existing findings.
2. Do not claim CI evidence in any artefact until a pipeline run has actually happened.

**Verify:** `cd /var/db/repos/haven-overlay && ls .gitlab-ci.yml`

**Commit:** `ci/overlay: record that no ci evidence exists yet and that the first push is the real test` (conventional-commit style; only the files named above are staged)
