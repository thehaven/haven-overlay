## ADDED Requirements

### Requirement: A pipeline runs on every push to master and every merge request

The repository SHALL contain a GitLab CI pipeline that runs on every push to `master` and on every merge request.

**Expected state:** `.gitlab-ci.yml` exists at the repository root and defines the jobs named in this specification.
**Verification command:** `ls .gitlab-ci.yml`
**Rollback command:** `git revert <commit>`
[SEC] [CMP]

#### Scenario: A push to master triggers the pipeline

- **WHEN** a commit is pushed to `master`
- **THEN** the pipeline runs and every gating job reports a result

### Requirement: Changed ebuilds are validated against their recorded digests

The pipeline SHALL validate the digests recorded in each changed ebuild's `Manifest` against its `SRC_URI`.

**Expected state:** a changed ebuild whose recorded digest does not match fails the job; an unchanged ebuild is not validated.
**Verification command:** `ebuild <changed-ebuild> manifest`
**Rollback command:** `git revert <commit>`
[SEC] [CMP]

#### Scenario: A tampered digest fails the job

- **WHEN** a changed ebuild's recorded digest does not match the fetched source
- **THEN** the `manifest-verify` job fails and the pipeline is red

### Requirement: The overlay test suite gates the pipeline

The pipeline SHALL run the overlay's own test suite under `scripts/tests/` and SHALL fail the pipeline when a test fails.

**Expected state:** the suite runs in full; a failing test fails the pipeline; a test is never silenced to reach green.
**Verification command:** `pytest scripts/tests/ -q`
**Rollback command:** `git revert <commit>`
[CMP]

#### Scenario: A failing test blocks the pipeline

- **WHEN** a test under `scripts/tests/` fails
- **THEN** the `overlay-tests` job fails and no other job's success masks it

### Requirement: The verify script family gates the pipeline

The pipeline SHALL run the `scripts/verify-*.sh` family and SHALL fail the pipeline when a script reports a finding.

**Expected state:** every `verify-*.sh` script runs; a script's own exit status decides the job, not its output text.
**Verification command:** `bash scripts/verify-git-uris.sh`
**Rollback command:** `git revert <commit>`
[SEC] [CMP]

#### Scenario: A verify script reports a finding

- **WHEN** a `scripts/verify-*.sh` script exits non-zero
- **THEN** the `verify-scripts` job fails

### Requirement: The advisory blocklist gate runs once the sibling change lands

The pipeline SHALL run `scripts/verify-vuln-blocklist.sh` and SHALL fail the pipeline when it reports drift, once that script exists.

**Expected state:** the job is present and gates; before the sibling change lands the job is absent and the pipeline records that fact.
**Verification command:** `ls scripts/verify-vuln-blocklist.sh`
**Rollback command:** `git revert <commit>`
[SEC]

#### Scenario: The blocklist gate reports drift

- **WHEN** the advisory feed and the generated mask region disagree
- **THEN** the `blocklist-gate` job fails

### Requirement: The metadata cache is reported and never gates

The pipeline SHALL report whether `metadata/md5-cache/` is stale and SHALL NOT fail the pipeline because of it.

**Expected state:** the report is emitted as job output; the job never fails on cache staleness; no cache file is written by the pipeline.
**Verification command:** `git status --porcelain -- metadata/md5-cache`
**Rollback command:** `git revert <commit>`
[CMP]

#### Scenario: The cache is stale but the pipeline still passes

- **WHEN** `metadata/md5-cache/` is out of date
- **THEN** the report says so and every gating job is unaffected

### Requirement: The pipeline never writes to the repository

The pipeline SHALL NOT commit, push, or otherwise modify the working tree, and SHALL NOT stage or write `metadata/md5-cache/`.

**Expected state:** after a pipeline run the working tree is unchanged; `egencache` is only ever run in a scratch copy.
**Verification command:** `git status --porcelain`
**Rollback command:** `git revert <commit>`
[SEC] [CMP]

#### Scenario: A run leaves the tree untouched

- **WHEN** the pipeline completes
- **THEN** `git status --porcelain` is empty and no commit was created
