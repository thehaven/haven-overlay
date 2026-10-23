# Implementation Plan - declare-osv-scanner-optional-dependency

## Existing context

1. Read `report.md` and `investigation.md` first. Do not re-derive the defect; they carry the verbatim reproduction.
2. The subject is `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild` only. `IUSE` is on line 19 and the RDEPEND block opens on line 21.
3. The upstream orchestrator invokes `osv-scanner` with an ABSOLUTE command name, so the binary must be on PATH. The binary is provided by `app-vuln/osv-scanner`, which the overlay already packages (ebuilds 1.9.1 through 2.7.0). Only the dependency EDGE is missing.
4. Upstream's engine default is `.get("osv", True)`, so the engine runs on every host today. The USE flag MUST therefore default ON or this change silently changes runtime behaviour.
5. The upstream sibling `declare-scanner-engine-dependencies` owns the osv-scanner 2.x command line and the per-engine exit-code contract. This change declares the dependency; it does not make the engine work. Do not attempt to fix the invocation here.
6. The upstream sibling's fix is a RUNTIME CAPABILITY PROBE covering both the v1 top-level CLI and the v2 `scan source` CLI, so the version floor must admit both shapes.
7. An operator building with `-osv` must ALSO set `[scanners] osv = false` in the config, or the upstream sibling will report the engine as failed rather than skipped. This coupling must be documented in the ebuild.
8. `PYTHON_COMPAT=( python3_{11..14} )` is left untouched - it deviates from the estate convention downwards and is a different change.
9. Every pytest invocation needs `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1` on this host.
10. This repository has NO CI, so no task may claim CI evidence.
11. Never silence, skip or xfail a test to reach green.

### 0. Preconditions and baseline

## Task 0.1 - Record the upstream sibling state

**Goal:** Record the upstream sibling state.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Confirm whether the upstream sibling change `declare-scanner-engine-dependencies` (in /storage/home/haven/projects/vuln-scanner) has landed.
2. Record its state in this task. The packaging edge is INDEPENDENT of the invocation fix, so do not block on it.
3. Do not modify the upstream repository from this change.

**Verify:** `ls /storage/home/haven/projects/vuln-scanner/openspec/changes/declare-scanner-engine-dependencies/`

**Commit:** `dev-util/vuln-scanner: record the upstream sibling state`

## Task 0.2 - Record the baseline packaging state

**Goal:** Record the baseline packaging state.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Capture the current IUSE line and the RDEPEND block verbatim into the task output.
2. Capture `emerge --pretend dev-util/vuln-scanner` so the before-state dependency set is on record.
3. Record the installed state: `ls -d /var/db/pkg/dev-util/vuln-scanner*` (absent on this host).

**Verify:** `emerge --pretend --color=n dev-util/vuln-scanner`

**Commit:** `dev-util/vuln-scanner: record the baseline packaging state`

## Task 0.3 - Confirm the overlay does not already declare the edge elsewhere

**Goal:** Confirm the overlay does not already declare the edge elsewhere.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Search every ebuild in the overlay for `app-vuln/osv-scanner`.
2. Confirm the only hits are the package's own directory (no other ebuild declares the dependency).
3. This is the overlay's duplicate pre-flight: the edge belongs in ONE ebuild, in THIS ebuild.

**Verify:** `rtk grep -rc 'app-vuln/osv-scanner' --include='*.ebuild' | grep -v ':0'`

**Commit:** `dev-util/vuln-scanner: confirm the overlay does not already declare the edge elsewhere`

### 1. RED - reproduce the missing edge

## Task 1.1 - Write the failing coverage test for executed binaries

**Goal:** Write the failing coverage test for executed binaries.

**Files:**
- `scripts/tests/test_vuln_scanner_ebuild.py`

**Steps:**
1. Create the test file. It reads the ebuild's RDEPEND and extracts the `app-vuln/*` atoms.
2. It reads the upstream orchestrator source at /storage/home/haven/projects/vuln-scanner/src/vuln_scanner/orchestrator.py and extracts the external binary names it invokes (trivy, grype, osv-scanner, dependency-check).
3. Assert every invoked binary that resolves to an `app-vuln/*` package has a matching RDEPEND edge.
4. RUN IT. It MUST fail, naming osv-scanner as the uncovered binary. Record the verbatim failure.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/test_vuln_scanner_ebuild.py -v --tb=short`

**Commit:** `dev-util/vuln-scanner: write the failing coverage test for executed binaries`

## Task 1.2 - Write the failing USE-flag-to-dependency test

**Goal:** Write the failing USE-flag-to-dependency test.

**Files:**
- `scripts/tests/test_vuln_scanner_ebuild.py`

**Steps:**
1. Extend the test file. For each engine USE flag in IUSE, assert a matching optional RDEPEND edge of the form `<flag>? ( app-vuln/<pkg> )`.
2. Assert the reverse too: no optional app-vuln edge exists without a USE flag.
3. RUN IT. It MUST fail on the missing osv edge. Record the verbatim failure.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/test_vuln_scanner_ebuild.py -v --tb=short`

**Commit:** `dev-util/vuln-scanner: write the failing use-flag-to-dependency test`

## Task 1.3 - Write the failing default-on test

**Goal:** Write the failing default-on test.

**Files:**
- `scripts/tests/test_vuln_scanner_ebuild.py`

**Steps:**
1. Assert the osv USE flag is present AND enabled by default (`+osv`), matching the upstream `.get("osv", True)` default.
2. Assert the same for the three existing engine flags so the test documents the convention rather than one flag.
3. RUN IT. It MUST fail on osv. Record the verbatim failure.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/test_vuln_scanner_ebuild.py -v --tb=short`

**Commit:** `dev-util/vuln-scanner: write the failing default-on test`

## Task 1.4 - Write the failing unknown-flag test

**Goal:** Write the failing unknown-flag test.

**Files:**
- `scripts/tests/test_vuln_scanner_ebuild.py`

**Steps:**
1. Assert every USE flag in the ebuild corresponds to a package the upstream orchestrator knows about.
2. This catches a stray flag added without an engine, which would install a dependency nothing uses.
3. RUN IT. It MUST PASS at this point (no stray flags exist yet) - record that so the GREEN step cannot regress it.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/test_vuln_scanner_ebuild.py -v --tb=short`

**Commit:** `dev-util/vuln-scanner: write the failing unknown-flag test`

### 2. GREEN - the dependency edge and its version floor

## Task 2.1 - Add the app-vuln/osv-scanner RDEPEND edge

**Goal:** Add the app-vuln/osv-scanner RDEPEND edge.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Add `osv? ( app-vuln/osv-scanner )` to the RDEPEND block, alongside the existing trivy/grype/depcheck edges.
2. Place it after the depcheck line so the engine edges stay in one contiguous group.
3. Re-run the group 1 tests. 1.1 and 1.2 MUST now pass; 1.3 will still fail until the USE flag lands.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/test_vuln_scanner_ebuild.py -v --tb=short`

**Commit:** `dev-util/vuln-scanner: add the app-vuln/osv-scanner rdepend edge`

## Task 2.2 - Record the version floor for the edge

**Goal:** Record the version floor for the edge.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. The overlay ships app-vuln/osv-scanner 1.9.1 through 2.7.0 and the upstream sibling's fix is a RUNTIME CAPABILITY PROBE covering both the v1 top-level CLI and the v2 `scan source` CLI.
2. Therefore the floor is `>=app-vuln/osv-scanner-1.9.1` - the oldest shape the sibling supports - not a v2-only floor.
3. Write the constraint with that reasoning as a comment on the RDEPEND line.

**Verify:** `rtk grep -n 'app-vuln/osv-scanner' dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Commit:** `dev-util/vuln-scanner: record the version floor for the edge`

## Task 2.3 - Assert the floor does not exclude a supported shape

**Goal:** Assert the floor does not exclude a supported shape.

**Files:**
- `scripts/tests/test_vuln_scanner_ebuild.py`

**Steps:**
1. Assert the version floor is satisfied by every osv-scanner ebuild version the overlay ships (1.9.1 and 2.x).
2. Assert it does NOT require a version the sibling cannot drive.
3. Re-run the whole test file; everything except the USE-flag default (1.3) MUST pass.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/test_vuln_scanner_ebuild.py -v --tb=short`

**Commit:** `dev-util/vuln-scanner: assert the floor does not exclude a supported shape`

### 3. GREEN - the USE flag default and the operational coupling

## Task 3.1 - Add the osv USE flag defaulting on

**Goal:** Add the osv USE flag defaulting on.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Add `osv` to IUSE and enable it by default, so IUSE reads `+cron +pdf +trivy +grype +depcheck +osv`.
2. Defaulting ON is required: upstream `.get("osv", True)` already runs the engine, so gating it OFF by default would change runtime behaviour on every existing host.
3. Re-run the group 1 tests. All MUST now pass.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/test_vuln_scanner_ebuild.py -v --tb=short`

**Commit:** `dev-util/vuln-scanner: add the osv use flag defaulting on`

## Task 3.2 - Document the -osv coupling in the ebuild

**Goal:** Document the -osv coupling in the ebuild.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. An operator who builds with `-osv` must ALSO set `[scanners] osv = false` in /etc/vuln-scanner/config.toml.
2. Otherwise the upstream orchestrator still tries to invoke the binary and, once the upstream sibling lands, reports the engine as FAILED rather than skipped.
3. Write this coupling as an explicit comment block in the ebuild, naming the config key and the file.

**Verify:** `rtk grep -n 'scanners' dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Commit:** `dev-util/vuln-scanner: document the -osv coupling in the ebuild`

## Task 3.3 - Record the upstream sibling dependency without claiming to fix it

**Goal:** Record the upstream sibling dependency without claiming to fix it.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Write a comment naming the upstream sibling change `declare-scanner-engine-dependencies` as the owner of the osv-scanner 2.x command line and the per-engine exit-code contract.
2. State plainly that this ebuild change declares the DEPENDENCY and does NOT make the engine work.
3. Do not edit the upstream repository and do not add a workaround invocation here.

**Verify:** `rtk grep -n 'declare-scanner-engine-dependencies' dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Commit:** `dev-util/vuln-scanner: record the upstream sibling dependency without claiming to fix it`

### 4. Documentation and packaging conventions

## Task 4.1 - Confirm the ebuild still parses and satisfies its own conventions

**Goal:** Confirm the ebuild still parses and satisfies its own conventions.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Run `ebuild <ebuild> manifest` and confirm no syntax error.
2. Confirm the file is mode 0644 and owned by the overlay user.
3. Confirm no `\$` appears in a variable assignment - in an ebuild that is a literal, not a variable.

**Verify:** `ebuild dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild manifest`

**Commit:** `dev-util/vuln-scanner: confirm the ebuild still parses and satisfies its own conventions`

## Task 4.2 - Confirm the Python compatibility line is untouched

**Goal:** Confirm the Python compatibility line is untouched.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Leave `PYTHON_COMPAT=( python3_{11..14} )` exactly as it is.
2. It deviates from the estate convention `python3_{12..14}` but downwards, which is not the `python3_15` rejection the overlay documents, and changing it is a different change with a different blast radius.
3. Record the observation in the task output so it is not lost.

**Verify:** `rtk grep -n 'PYTHON_COMPAT' dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Commit:** `dev-util/vuln-scanner: confirm the python compatibility line is untouched`

## Task 4.3 - Confirm no md5-cache churn is introduced

**Goal:** Confirm no md5-cache churn is introduced.

**Files:**
- `metadata/md5-cache/`

**Steps:**
1. Run egencache for the repo and confirm whether it rewrites unrelated md5-cache entries.
2. If it does, revert them with `git checkout -- metadata/md5-cache/` and delete untracked entries.
3. The overlay's md5-cache is not maintained per-commit; it must never be staged.

**Verify:** `git diff --name-only -- metadata/md5-cache/`

**Commit:** `dev-util/vuln-scanner: confirm no md5-cache churn is introduced`

### 5. Build, install and smoke

## Task 5.1 - Build the package with the new edge

**Goal:** Build the package with the new edge.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Run `ebuild <ebuild> clean install` (or emerge --pretend first to confirm the dependency resolves).
2. Confirm app-vuln/osv-scanner is pulled in by the dependency graph, not merely present by accident.

**Verify:** `emerge --pretend --color=n dev-util/vuln-scanner`

**Commit:** `dev-util/vuln-scanner: build the package with the new edge`

## Task 5.2 - Prove the engine binary is reachable through the dependency

**Goal:** Prove the engine binary is reachable through the dependency.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. With the package installed, confirm `command -v osv-scanner` resolves.
2. Confirm the resolved binary is the one the portage dependency provides.
3. Confirm the installed set contains dev-util/vuln-scanner AND app-vuln/osv-scanner.

**Verify:** `ls -d /var/db/pkg/dev-util/vuln-scanner* /var/db/pkg/app-vuln/osv-scanner*`

**Commit:** `dev-util/vuln-scanner: prove the engine binary is reachable through the dependency`

## Task 5.3 - Confirm the default build still runs the osv engine

**Goal:** Confirm the default build still runs the osv engine.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. With the default (+osv) build, confirm the orchestrator's engine set still includes osv, matching upstream's default.
2. Confirm the config file the package installs is unchanged in the engine-relevant parts.

**Verify:** `rtk grep -n 'osv' /etc/vuln-scanner/config.toml`

**Commit:** `dev-util/vuln-scanner: confirm the default build still runs the osv engine`

## Task 5.4 - Prove the -osv build is documented and observable

**Goal:** Prove the -osv build is documented and observable.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Build with `-osv` in a pretend run and confirm the dependency edge disappears from the graph.
2. Confirm the ebuild comment naming the required config change is present in the file.
3. Do NOT unmerge the real installation on this host.

**Verify:** `emerge --pretend --color=n dev-util/vuln-scanner USE="-osv"`

**Commit:** `dev-util/vuln-scanner: prove the -osv build is documented and observable`

### 6. Regression sweep

## Task 6.1 - Run the overlay's full ebuild test suite

**Goal:** Run the overlay's full ebuild test suite.

**Files:**
- `scripts/tests/`

**Steps:**
1. Run `pytest scripts/tests/` with the plugin-autoload guard.
2. Any failure caused by this change MUST be fixed. A pre-existing failure MAY be recorded as a reasoned exception against the 0.2 baseline.
3. Do NOT silence, skip or xfail a test to reach green.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/ -v --tb=short`

**Commit:** `dev-util/vuln-scanner: run the overlay's full ebuild test suite`

## Task 6.2 - Re-run the whole reproduction from report.md

**Goal:** Re-run the whole reproduction from report.md.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Re-run every numbered reproduction step from report.md against the fixed ebuild.
2. Confirm the reported symptom no longer reproduces: the executed-binary coverage test passes.
3. Record each step's outcome verbatim.

**Verify:** `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/test_vuln_scanner_ebuild.py -v --tb=short`

**Commit:** `dev-util/vuln-scanner: re-run the whole reproduction from report.md`

## Task 6.3 - Confirm the change's declared scope

**Goal:** Confirm the change's declared scope.

**Files:**
- `dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild`

**Steps:**
1. Confirm the diff touches only the ebuild, the new test file, and this change's artefacts.
2. Confirm `git diff --name-only -- metadata/md5-cache/` is empty.
3. Confirm no file outside this change's directory and the two named source files was modified.

**Verify:** `git status --short`

**Commit:** `dev-util/vuln-scanner: confirm the change's declared scope`

## Rollback

See the `## Rollback` section in `tasks.md` for the per-group revert table and the residual state of each. The three GREEN groups are one logical change and should land as one commit; group 1 is tests-only and lands separately so the failure is on record before the fix.
