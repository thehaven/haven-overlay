# Tasks - declare-osv-scanner-optional-dependency

## Hard constraints

- Do NOT stage `metadata/md5-cache/`. It is not maintained per-commit in this overlay; if egencache rewrites it, revert with `git checkout -- metadata/md5-cache/` and delete untracked entries.
- Do NOT touch `/var/db/repos/haven-overlay/app-vuln/osv-scanner/` - the dependency is already packaged; this change adds an EDGE, not a package.
- Do NOT modify `/storage/home/haven/projects/vuln-scanner` - the upstream repository is a separate repository with its own changes.
- Do NOT claim this change repairs the upstream osv-scanner 2.x invocation. That belongs to the upstream sibling `declare-scanner-engine-dependencies`.
- Never silence, skip or xfail a test to reach green.
- Every pytest invocation needs `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1` on this host: the installed hydra-core registers a pytest11 plugin that fails at collection because of the pinned omegaconf/antlr4 combination. That is a host-environment issue, not a defect in this overlay.
- `PYTHON_COMPAT` stays as it is. Do not add `python3_15`.
- Conventional-commit style: `<category>/<pkg>: <verb> <object>`.


## 0. Preconditions and baseline

- [ ] 0.1 Record the upstream sibling state [spec: R1] [unit]
- [ ] 0.2 Record the baseline packaging state [spec: R1] [unit]
- [ ] 0.3 Confirm the overlay does not already declare the edge elsewhere [spec: R5] [unit]

## 1. RED - reproduce the missing edge

- [ ] 1.1 Write the failing coverage test for executed binaries [spec: R1] [unit]
- [ ] 1.2 Write the failing USE-flag-to-dependency test [spec: R1] [unit]
- [ ] 1.3 Write the failing default-on test [spec: R2] [unit]
- [ ] 1.4 Write the failing unknown-flag test [spec: R5] [unit]

## 2. GREEN - the dependency edge and its version floor

- [ ] 2.1 Add the app-vuln/osv-scanner RDEPEND edge [spec: R1] [unit]
- [ ] 2.2 Record the version floor for the edge [spec: R1] [unit]
- [ ] 2.3 Assert the floor does not exclude a supported shape [spec: R4] [unit]

## 3. GREEN - the USE flag default and the operational coupling

- [ ] 3.1 Add the osv USE flag defaulting on [spec: R2] [unit]
- [ ] 3.2 Document the -osv coupling in the ebuild [spec: R3] [unit]
- [ ] 3.3 Record the upstream sibling dependency without claiming to fix it [spec: R6] [unit]

## 4. Documentation and packaging conventions

- [ ] 4.1 Confirm the ebuild still parses and satisfies its own conventions [spec: R5] [unit]
- [ ] 4.2 Confirm the Python compatibility line is untouched [spec: R5] [unit]
- [ ] 4.3 Confirm no md5-cache churn is introduced [spec: R5] [unit]

## 5. Build, install and smoke

- [ ] 5.1 Build the package with the new edge [spec: R1] [integration]
- [ ] 5.2 Prove the engine binary is reachable through the dependency [spec: R1] [smoke]
- [ ] 5.3 Confirm the default build still runs the osv engine [spec: R4] [smoke]
- [ ] 5.4 Prove the -osv build is documented and observable [spec: R3] [smoke]

## 6. Regression sweep

- [ ] 6.1 Run the overlay's full ebuild test suite [spec: R5] [unit]
- [ ] 6.2 Re-run the whole reproduction from report.md [spec: R1] [integration]
- [ ] 6.3 Confirm the change's declared scope [spec: R6] [unit]

## Rollback

Each group is an independently revertible commit. Revert in this order:

| Group | Revert | Residual state |
|---|---|---|
| 1 RED | last | None - tests only. Reverting restores the undetected state. |
| 2 dependency edge | with group 3 | The RDEPEND edge is removed but the USE flag may remain; revert 3 first. |
| 3 USE flag and coupling | first of the GREEN groups | The engine is no longer declared; reverts to the accidental-availability state. |
| 4 documentation | independently | Comments only. |
| 5 build/install/smoke | independently | No persisted state in the overlay. |
| 6 regression sweep | independently | No persisted state in the overlay. |

A full revert returns the ebuild to the state recorded in task 0.2. That state is the defect being fixed: an engine whose presence is an accident of an unrelated atom. There is no migration, cache or persisted state to unwind.
