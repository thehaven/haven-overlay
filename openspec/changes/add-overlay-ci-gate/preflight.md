# Preflight — add-overlay-ci-gate

## Reachability Checks

| Check | Command | Observed | Verdict |
|---|---|---|---|
| GitLab remote reachable | `git ls-remote origin HEAD` | `e1b5e9cc3dcdc17f48c91c84f9de11d646484acb  HEAD  exit=0` | PASS |
| HTTPS push URL reachable | `git ls-remote https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay.git HEAD` | same SHA, `exit=0` | PASS |
| GitLab CI-lint API | `curl -s -o /dev/null -w '%{http_code}' https://gitlab-ee.thehavennet.org.uk/api/v4/ci/lint` | `404` | **NOT AVAILABLE** — the endpoint requires an authenticated token; project-side pipeline linting could not be performed from this host. Local YAML validation is the substitute instrument. |
| Local YAML parser | `python3 -c "import yaml; print(yaml.__version__)"` | `6.0.3` | PASS — `.gitlab-ci.yml` can be syntax-validated locally with no GitLab API |
| Read-only ebuild validator | `pkgcheck --version` / `pkgcheck scan --help` | `0.10.39` at `/usr/sbin/pkgcheck`; `pkgcheck scan` accepts positional `TARGET` atoms and `--exit ITEM[,...]` | PASS — this is the read-only instrument for the digest gate |
| `portageq` | `command -v portageq` | `/usr/sbin/portageq` | PASS |
| Changed-ebuild derivation | `git diff --name-only --diff-filter=ACMR HEAD~1 HEAD -- '*.ebuild'` | command works (returned `0` for that commit pair, which touched no ebuild) | PASS |
| Network egress (test suite) | `scripts/tests/test_src_uri_fetchable.py` | present and network-dependent; it is the sole reason the suite exceeds 120 s | PASS WITH CAVEAT — the CI job requires network egress and a generous timeout |
| Overlay inventory | `find . -name '*.ebuild' -not -path './metadata/*'` / `ls -1 -d */` | 3,288 ebuilds / 52 categories | PASS — scale recorded |
| `egencache` dry-run capability | `egencache --help` | options are `--update`, `--update-use-local-desc`, `--update-changelogs`, `--update-pkg-desc-index`, `--update-manifests`, `--repo`, `--repositories-configuration` — **no `--dry-run`** | FAIL (by design) — `egencache` MUTATES `metadata/md5-cache/`; it may only ever run in a scratch copy, never in the tree the pipeline validates |

### Correction to an earlier working assumption
Earlier artifacts in this session recorded that "the GitLab remote is unreachable from this host". **That is no longer true.** Both the SSH fetch URL and the HTTPS push URL resolve as of 2026-10-23 (see the table). Any artifact or report repeating the older claim is factually wrong and is corrected here.

## Credentials

**None are required, and none are introduced.**

- The pipeline **never pushes and never commits**. The overlay's workflow is that commits land directly on `master` with no PR merge step, so there is no credential to fork for a write.
- No GitLab API token is needed for the jobs as designed: the CI-lint endpoint is unavailable without one and is therefore **not** a gate — the pipeline's own run is the lint.
- `pkgcheck`, `portageq` and `ebuild` are local binaries already present on a Gentoo host.
- The `verify-*.sh` family performs no authenticated network calls except `scripts/verify-git-uris.sh`, which probes public `EGIT_REPO_URI` URLs as the `portage` user — the same context in which a real build fetches them.
- The nightly bump job's credentials (`/etc/ebuild-updater/config.toml`, including a plaintext GitHub PAT) are **out of scope** for this change. The CI pipeline never reads that file. The credential exposure is owned by the ebuild-updater change `support-credential-indirection`; this change neither introduces nor remediates it.

## Dry-Run Output

### Baseline of the overlay's own test suite (recorded so a pre-existing failure is distinguishable from one the pipeline introduces)

Command:
```
PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 pytest scripts/tests/ -q --tb=line
```

| Test file | Result |
|---|---|
| `scripts/tests/test_gepa_ebuild.py` | 6 passed |
| `scripts/tests/test_grafonnet_ebuild.py` | 4 passed |
| `scripts/tests/test_headroom_ai_ebuild.py` | 1 passed |
| `scripts/tests/test_hermes_evolution_ebuild.py` | 8 passed |
| `scripts/tests/test_litellm_ebuild.py` | 30 passed |
| `scripts/tests/test_mcp_pin.py` | 1 passed |
| `scripts/tests/test_opencode_plugin_swarm_ebuild.py` | **17 collected, 14 passed, 3 FAILED** |
| `scripts/tests/test_overlay_duplicates.py` | 2 passed |
| `scripts/tests/test_pep517_backend_drift.py` | **HANGS — never completes (killed at 120 s and again at 400 s)** |
| `scripts/tests/test_prime_agent_ebuild.py` | not reached (the run hung before it) |
| `scripts/tests/test_src_uri_fetchable.py` | not reached in the hanging run; network-dependent and the reason the suite exceeds 120 s when included |

The three failures, verbatim:
```
1. [FAIL] scripts/tests/test_opencode_plugin_swarm_ebuild.py::test_referenced_patches_and_shims_exist[ebuild_path3]
2. [FAIL] scripts/tests/test_opencode_plugin_swarm_ebuild.py::test_referenced_patches_and_shims_exist[ebuild_path4]
3. [FAIL] scripts/tests/test_opencode_plugin_swarm_ebuild.py::test_referenced_patches_and_shims_exist[ebuild_path5]
```
with the assertion message `opencode-plugin-swarm-7.198.2.ebuild: Referenced patch does not exist: openco…` at `scripts/tests/test_opencode_plugin_swarm_ebuild.py:83`.

Isolated confirmation: `pytest scripts/tests/test_opencode_plugin_swarm_ebuild.py -q --tb=no -rf` → **17 passed, 3 failed in 0.10 s**.

**These three failures are PRE-EXISTING and are NOT caused by this change.** They are recorded as the baseline. The pipeline must be configured to distinguish them:
- the failing assertion is in the `opencode-plugin-swarm` package's own ebuild/patch references, which this change does not touch;
- the gate is therefore specified as **"no NEW failures relative to the recorded baseline"**, not "zero failures", until the baseline is cleared by a separate change.

### Baseline of the `pkgcheck` digest gate (read-only, changed-ebuild scoped)

`pkgcheck scan --repo haven-overlay <changed-atom>`:
- **Non-Python packages scan cleanly** — `pkgcheck scan --repo haven-overlay app-vuln/trivy` produced normal output.
- **`dev-python` packages CRASH** on this host:
  ```
  File "/usr/lib/python3.14/site-packages/pkgcheck/checks/python.py", line 366, in scan_tree_recursively
      for x in deptree:
  TypeError: 'ContainmentMatch' object is not iterable
  ```
  This is a **pkgcheck-versus-Python-3.14 incompatibility in pkgcheck's own `REQUIRED_USE` check**, not an overlay defect. A pkgcheck crash must be classified as **"not checked", never as "clean"** — a crashed check that reported success would be the single most dangerous failure mode this gate could have.
- **pkgcheck has a large pre-existing finding baseline on this overlay's own ebuilds**, e.g.:
  ```
  RedundantVersion:     version 0.74.0: slot(0) keywords are overshadowed by versions: 0.75.0, 0.76.0, 0.76.1
  UnknownRestrict:      version 0.74.0: unknown RESTRICT="network-sandbox"
  VariableOrderWrong:   version 0.74.0: variable IUSE should occur before RESTRICT
  WhitespaceFound:      version 0.74.0: ebuild has trailing whitespace on line: 47
  ```
  The `UnknownRestrict` finding is decisive: pkgcheck 0.10.39 does not know portage's `network-sandbox` feature, which this overlay's `AGENTS.md` documents as **correct practice**. **pkgcheck therefore flags correct ebuilds as wrong.** The gate must never gate on a repo-wide finding count; it is scoped to changed ebuilds and tolerates the known-baseline classes.

### Excluded instruments (and why)
- `ebuild <file> manifest` — **WRITES** the `Manifest` file (and `--force` also fetches distfiles). It may only ever run in a scratch copy, never in the tree the pipeline validates. `pkgcheck` is used instead because it is read-only.
- `egencache --update` — mutates `metadata/md5-cache/` and has no dry-run mode. Excluded from the gating path entirely.

### Dry-run of the planned pipeline shape
No pipeline file exists yet, so the dry-run is a syntax and shape validation of the intended artefacts:
- `python3 -c "import yaml,sys; yaml.safe_load(open('.gitlab-ci.yml'))"` — will run once the file exists; **the YAML parse itself is the local substitute for the unavailable GitLab CI-lint API**.
- `git diff --name-only --diff-filter=ACMR HEAD~1 HEAD -- '*.ebuild'` — verified working; it is the mechanism that scopes both the `pkgcheck` invocation and the manifest check to changed ebuilds only.
- `pkgcheck scan --repo haven-overlay <atom>` — verified working on a non-Python package.

## GATE

**PASS — proceed to apply**, with three conditions carried into the tasks:

1. **A per-job timeout is mandatory.** `scripts/tests/test_pep517_backend_drift.py` never completes on this host (killed at 120 s and again at 400 s). Without a job timeout the CI pipeline will hang rather than fail. The pipeline MUST set an explicit `timeout` on every job, and the hanging test must be isolated or skipped **with the skip recorded in the job output** — never silently dropped.
2. **The test gate is "no NEW failures relative to the recorded baseline", not "zero failures".** The three `test_referenced_patches_and_shims_exist` failures are pre-existing (recorded above with their exact node ids). A gate that demands zero failures would be red from its first run and would train the operator to ignore it.
3. **A pkgcheck crash is "not checked", never "clean".** The `dev-python` crash is a known pkgcheck-on-Python-3.14 limitation. The gate must classify a crash as an inconclusive result and report it as such, not as a pass.

The GitLab remote is reachable, the YAML validator is available locally, `pkgcheck` provides a read-only changed-ebuild-scoped digest check, and the baseline is recorded. No credential is required, no dry-run is blocked, and no gate depends on an instrument that mutates the working tree.
