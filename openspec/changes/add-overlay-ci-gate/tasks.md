# Tasks - add-overlay-ci-gate
Each task names the spec requirement it fulfils. A task is at most 200 LOC, touches at most 5 files, is independently committable, and leaves the tree in a working state.
## Hard constraints

- The pipeline **never** writes to the repository. `ebuild <file> manifest` writes the
  `Manifest` file and `egencache` mutates `metadata/md5-cache/`; both are therefore
  confined to a scratch copy and never to the tree the pipeline validates.
- The pipeline **never** commits, pushes, or opens a merge request. Commits land
  directly on `master`; a CI writer would race the nightly bump job.
- `metadata/md5-cache/` is **never** staged, written, or gated. It is not maintained
  per commit (see `AGENTS.md`); the webhost regenerates it in bulk.
- The pipeline **gates changed ebuilds only**. The overlay holds 3288 ebuilds across
  52 categories; a whole-tree validation per push is not viable, and the repo already
  carries a large pre-existing `pkgcheck` finding baseline that must never be mistaken
  for a regression.
- Never silence, skip, or `xfail` a test to make the pipeline green. A pre-existing
  failure is recorded as a pre-existing failure, with its name and count.
- Every `pytest` invocation needs `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1`. The host's
  `hydra-core` registers a `pytest11` plugin that breaks collection; this is a host
  environment issue, not an overlay defect.
- `rtk grep` truncates long output. Use `rtk grep -c` for counts and read with an
  offset for exact line text.
- Do not modify any ebuild in this change. The subject is the pipeline, not the
  packages.

## 0. Preconditions and baseline
- [ ] 0.1 Record the baseline state of the overlay before any pipeline exists [spec: A pipeline runs on every push to master and every merge request] [unit]
- [ ] 0.2 Confirm the working tree is clean of unintended changes before starting [spec: The pipeline never writes to the repository] [unit]
- [ ] 0.3 Confirm the test-suite baseline recorded in preflight.md is the current baseline [spec: The overlay test suite gates the pipeline] [unit]

## 1. RED - the pipeline specification is executable and read-only
- [ ] 1.1 Write a test that the pipeline definition is valid YAML with the expected job set [spec: A pipeline runs on every push to master and every merge request] [unit]
- [ ] 1.2 Write a test that no pipeline job writes to the repository [spec: The pipeline never writes to the repository] [unit]
- [ ] 1.3 Write a test that the digest gate targets only the changed ebuilds [spec: Changed ebuilds are validated against their recorded digests] [unit]

## 2. GREEN - the GitLab CI pipeline definition
- [ ] 2.1 Add .gitlab-ci.yml with the trigger rules and the job skeleton [spec: A pipeline runs on every push to master and every merge request] [unit]
- [ ] 2.2 Add the read-only job that derives the changed ebuild set [spec: The pipeline never writes to the repository] [unit]
- [ ] 2.3 Add the digest gate job scoped to the changed ebuilds [spec: Changed ebuilds are validated against their recorded digests] [unit]
- [ ] 2.4 Add the overlay test-suite job that gates the pipeline [spec: The overlay test suite gates the pipeline] [unit]
- [ ] 2.5 Add the verify-script job that runs the scripts/verify-*.sh family [spec: The verify script family gates the pipeline] [unit]
- [ ] 2.6 Add the advisory blocklist job, conditional on the sibling change landing [spec: The advisory blocklist gate runs once the sibling change lands] [unit]
- [ ] 2.7 Add the metadata-cache reporting job that never gates [spec: The metadata cache is reported and never gates] [unit]

## 3. GREEN - the local gate runner
- [ ] 3.1 Add the local gate runner script that the pipeline calls [spec: Changed ebuilds are validated against their recorded digests] [unit]
- [ ] 3.2 Add the local runner mode that executes the overlay test suite [spec: The overlay test suite gates the pipeline] [unit]
- [ ] 3.3 Add the local runner mode that executes the verify-script family [spec: The verify script family gates the pipeline] [unit]
- [ ] 3.4 Add the local runner mode for the advisory blocklist gate [spec: The advisory blocklist gate runs once the sibling change lands] [unit]
- [ ] 3.5 Add the local runner mode that reports the metadata cache without gating [spec: The metadata cache is reported and never gates] [unit]
- [ ] 3.6 Prove the local runner never mutates the repository [spec: The pipeline never writes to the repository] [unit]

## 4. Documentation and conventions
- [ ] 4.1 Document the pipeline in the overlay cheatsheet [spec: A pipeline runs on every push to master and every merge request] [unit]
- [ ] 4.2 Document the known pkgcheck baseline and the crash in the cheatsheet [spec: Changed ebuilds are validated against their recorded digests] [unit]
- [ ] 4.3 Record the metadata-cache convention in the cheatsheet [spec: The metadata cache is reported and never gates] [unit]

## 5. Live validation
- [ ] 5.1 Validate the pipeline YAML locally and record that GitLab lint was not possible [spec: A pipeline runs on every push to master and every merge request] [integration]
- [ ] 5.2 Run the digest gate against a real changed ebuild and observe the expected pkgcheck behaviour [spec: Changed ebuilds are validated against their recorded digests] [integration]
- [ ] 5.3 Run the test-suite mode and confirm it distinguishes the baseline from a new failure [spec: The overlay test suite gates the pipeline] [integration]
- [ ] 5.4 Run the verify-script mode and confirm each script's status is reported [spec: The verify script family gates the pipeline] [integration]
- [ ] 5.5 Run the metadata-cache mode and confirm the repository is byte-identical afterwards [spec: The metadata cache is reported and never gates] [integration]

## 6. Regression sweep
- [ ] 6.1 Run the full overlay test suite and record the outcome against the baseline [spec: The overlay test suite gates the pipeline] [unit]
- [ ] 6.2 Prove the final diff contains no write path and no metadata cache churn [spec: The pipeline never writes to the repository] [unit]
- [ ] 6.3 Record that no CI evidence exists yet and that the first push is the real test [spec: The metadata cache is reported and never gates] [unit]

## Rollback

Every task is a separate, independently revertible commit.

| Group | Reverts | Residual state |
|---|---|---|
| 0 Preconditions | none needed | baseline record only |
| 1 RED | revert last | tests only, no behaviour change |
| 2 Pipeline | revert together with group 3 | no pipeline, no local runner |
| 3 Local runner | revert together with group 2 | the scripts the pipeline called |
| 4 Documentation | independently revertible | docs only |
| 5 Live validation | no persisted state | nothing |
| 6 Regression sweep | no persisted state | nothing |

**Revert group 3 before group 2.** A pipeline that calls a runner script which
no longer exists is a pipeline that fails for the wrong reason. The safe
partial rollback is to revert the whole change with a single `git revert`,
because the pipeline never writes to the repository and therefore cannot leave
corrupt state behind. There is no database, cache or persisted state to
unwind, and `metadata/md5-cache/` is never touched by any task.
