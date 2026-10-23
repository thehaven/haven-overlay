## Change Summary

<!-- What infrastructure is changing and why -->

The overlay has **no continuous integration at all**. `ls .gitlab-ci.yml` → *No such file or directory*; `ls .github` → *No such file or directory*; `ls -1 .git/hooks/ | grep -v sample` → **empty**. Every gate the overlay owns is therefore hand-run by an operator who has to remember to run it: the eleven files under `scripts/tests/`, the five `scripts/verify-*.sh` scripts, `scripts/audit_pep517_backend_drift.py`, and the advisory blocklist gate `scripts/verify-vuln-blocklist.sh` introduced by the sibling change `add-ebuild-vulnerability-gate`.

That matters because the overlay is **3,288 ebuilds across 52 categories** (`find . -name '*.ebuild' -not -path './metadata/*' | wc -l` → 3288; `ls -1 -d */ | wc -l` → 52) and it is updated **unattended**. `/etc/cron.daily/ebuild-updater` runs daily and commits and pushes bumps to `master` with no human in the loop. The committed advisory-driven vulnerability gate changes that: it adds the ability to *refuse* a version — but a refusal mechanism that is only checked when a human remembers to check it is not a gate. The litellm 1.107.0 compromise is the worked example: the emergency response was a mask plus a hold in two files, and the hold was **inert for the nightly job** because the cron path resolved its configuration differently from an interactive run (see the sibling ebuild-updater change `honour-repo-config-outside-cwd`). The class of failure is not "the mask was wrong" — it is "nothing verified the mask, the hold, or the ebuild that was about to be written".

This change adds a **GitLab CI pipeline on the canonical remote** (`.gitlab-ci.yml`) that runs on every push to `master` and on merge requests, and that **gates** the merge:

| Job | What it checks | Gates? |
|---|---|---|
| `manifest-verify` | Each **changed** ebuild's recorded `Manifest` digests still match its `SRC_URI` | yes |
| `overlay-tests` | The overlay's own `scripts/tests/` suite (eleven files) | yes |
| `verify-scripts` | The `scripts/verify-*.sh` family | yes |
| `blocklist-gate` | `scripts/verify-vuln-blocklist.sh` from the sibling change | yes, once that sibling lands |
| `md5-cache-report` | Whether `metadata/md5-cache/` is stale — **reported only** | **no** |

### Decisions this proposal commits to

1. **GitLab CI, not GitHub Actions.** The canonical remote is `gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay`; `github.com/thehaven/haven-overlay` is a read-only public mirror. A gate that runs only on the mirror gates nothing.
2. **The pipeline never commits and never pushes.** The overlay's convention is that commits land directly on `master` with no PR workflow; a CI pipeline that writes back would race the nightly bump job.
3. **The pipeline never mutates the working tree.** `egencache --help` shows **no `--dry-run` option** — only `--update`, `--update-use-local-desc`, `--update-changelogs`, `--update-pkg-desc-index`, `--update-manifests`, `--repo`, `--repositories-configuration`. Any `egencache` run **mutates** `metadata/md5-cache/`, so `egencache` may only ever run inside a scratch copy, never in the checked-out tree the pipeline validates.
4. **`metadata/md5-cache/` never gates.** The overlay's own documented convention (AGENTS.md) is that the cache "is not maintained per-commit"; the webhost regenerates it in bulk. A pipeline that blocked on it would block on a condition the project has deliberately declared out of scope. It is reported, not enforced.
5. **Only changed ebuilds are validated, not the whole tree.** At 3,288 ebuilds a full-tree validation per push is not viable. The pipeline derives the changed set from the push's diff.
6. **Network access is required.** `scripts/tests/test_src_uri_fetchable.py` (11.4K) fetches upstream sources; the suite exceeded 120 s on this host, so the job needs a generous timeout and egress.

### Known limitation recorded up front

A CI pipeline gates **merges**, and this overlay's workflow does not use merges — commits land directly on `master`. A pipeline therefore cannot by itself prevent the nightly job from writing a bad ebuild. It closes the loop for **human** pushes and merge requests, and it makes the advisory gate *reviewable in a diff* rather than dependent on someone remembering to run it. The remaining unattended-write gap is closed by the upstream ebuild-updater changes (`honour-repo-config-outside-cwd` and `add-version-scoped-blocklist`), not here. Stating that plainly is part of the change.

### Governance gaps found (scaffold audit)

| Gap | Finding | Action |
|---|---|---|
| CI | No `.gitlab-ci.yml`, no `.github/`, no active git hooks | **closed by this change** |
| Scaffold engine | No `.scaffold*`/`scaffold*` configuration in the repo root | established-project branch; no backport required |
| Test harness | Eleven files under `scripts/tests/`; naming `test_*.py`; run with `pytest` | reused unchanged |
| Test runtime | The suite exceeds 120 s on this host; `test_src_uri_fetchable.py` is network-dependent | the job needs network and a generous timeout |
| Scale | 3,288 ebuilds / 52 categories | validate the changed set only |
| Metadata cache | `egencache` has no dry-run; the cache is not maintained per-commit | reported, never gated, never written |
| Secrets | No credential is needed by any job in this change | the pipeline needs no secret |

## Affected Environments

<!-- prod / staging / dev — which are affected -->

| Environment | Affected | Detail |
|---|---|---|
| `master` of `gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay` | **yes** | A `.gitlab-ci.yml` is added and every push to `master` and every merge request now runs it. |
| `github.com/thehaven/haven-overlay` (public read-only mirror) | no | No workflow is added there; the mirror stays read-only. A push to `master` is mirrored automatically. |
| Any host with the overlay installed | **no runtime effect** | The overlay's installed contents are unchanged. `emerge` behaviour is unaffected; the mask in `profiles/package.mask` and the hold in the root `ebuild-updater.toml` are untouched by this change. |
| The nightly bump job (`/etc/cron.daily/ebuild-updater`) | **no** | It pushes directly to `master` and does not wait for a pipeline. This change does **not** close that path — see the known limitation above. |
| This host as the development surface | yes | The `.gitlab-ci.yml` is authored and linted here; the pipeline itself first runs on the GitLab runner. |

**Reachability verified 2026-10-23 on this host** (this corrects an earlier working assumption that the GitLab remote was unreachable):

```
$ git remote -v
origin	ssh://git@gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay.git (fetch)
origin	https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay.git (push)

$ git ls-remote origin HEAD
e1b5e9cc3dcdc17f48c91c84f9de11d646484acb	HEAD        exit=0
```

Both the SSH fetch URL and the HTTPS push URL resolve. `origin`'s HEAD at the time of writing is `e1b5e9cc3dcdc17f48c91c84f9de11d646484acb`.

**No production deployment step.** There is nothing to deploy: the change adds one file to the repository and adds a pipeline to the GitLab project. There is no build artefact, no service restart and no host rollout.

## Rollback Strategy

<!-- How to revert this change -->

The change is a single added file plus a delta spec. Reverting is a single commit revert; there is no state to unwind.

| Artefact | Rollback |
|---|---|
| `.gitlab-ci.yml` | `git revert <commit>` — the file is removed and the pipeline disappears. Nothing else in the overlay referenced it. |
| `openspec/changes/add-overlay-ci-gate/` | `git revert <commit>` — the proposal, delta spec, preflight, tasks and plan are removed. |
| The pipeline's effect on `master` | none. The pipeline never writes to the repository, so reverting it cannot corrupt the tree. |

**Rollback is safe at any point.** Because the pipeline never mutates the working tree and never commits, there is no half-applied state to clean up: reverting the file restores exactly the previous behaviour, including the previous absence of CI. The one thing a rollback does **not** restore is the *attention* that was previously paid to running the gates by hand — that returns with it.

**No database, cache or state migration.** No credentials are introduced, so no credential rotation is required.

## Maintenance Window

<!-- Required? When? -->

**None required.** The change is additive and inert until the first push reaches GitLab.

- **No downtime.** Nothing is restarted, nothing is rebuilt, nothing is re-installed.
- **No maintenance window.** The overlay's installed contents do not change.
- **Additive only.** The one file added (`.gitlab-ci.yml`) is new; no existing file is modified, so there is no possibility of a partial application.
- **Reversible at any moment** with a single `git revert`, as set out above.
- **The pipeline's first run** may surface pre-existing failures in the overlay's own test suite. That is the point of the change, and it is why the preflight records the suite's baseline: a failure that predates the pipeline must be distinguishable from a failure the pipeline introduced. The preflight is the gate that establishes that baseline before the pipeline is enabled.
