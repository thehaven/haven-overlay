## Symptom

`dev-util/vuln-scanner` executes the `osv-scanner` binary at scan time but never declares it as a dependency, so the package manager does not guarantee the engine is present — and because the engine defaults to enabled, removing the separately-installed `app-vuln/osv-scanner` atom breaks the scanner with no dependency error at all.

## Environment

| Item | Value |
|---|---|
| Repo | `/var/db/repos/haven-overlay` (layman overlay, branch `master`) |
| Package under test | `dev-util/vuln-scanner` — `vuln-scanner-0.2.0.ebuild` (78 lines) |
| Upstream source | `https://gitlab-ee.thehavennet.org.uk/haven/vuln-scanner.git`, tag `v0.2.0` |
| Ebuild `IUSE` (line 19) | `+cron +pdf +trivy +grype +depcheck` — no `osv`, no `security` |
| Ebuild `RDEPEND` (lines 21–32) | `dev-python/{click,rich,tomlkit,jinja2,apprise}` + `trivy? ( app-vuln/trivy )` + `grype? ( app-vuln/grype )` + `depcheck? ( app-vuln/dependency-check )` + `cron? ( virtual/cron )` + `pdf? ( app-text/pandoc-bin )` — **no osv entry** |
| Overlay package available | `app-vuln/osv-scanner/` — ebuilds `1.9.1 2.3.8 2.4.0 2.5.0 2.5.1 2.6.0 2.7.0` |
| Binary on this host | `/usr/bin/osv-scanner` and `/usr/sbin/osv-scanner` (61.6 MB each), `osv-scanner version: 2.5.1` (`osv-scalibr 0.5.2`) |
| How the binary got here | `/var/db/pkg/app-vuln/osv-scanner-2.5.1/` — installed as a **separate atom**, not pulled in by `dev-util/vuln-scanner` |
| Upstream engine default | `orchestrator.py:422` — `self.config.get("scanners", {}).get("osv", True)` ⇒ **enabled unless explicitly disabled** |
| Portage | 3.0.82.2 |
| CI | **none** — no `.gitlab-ci.yml`, no `.github/`, no active `.git/hooks/` |

## Reproduction Steps

1. Confirm the ebuild declares the other three engines but not osv.
   ```
   $ rtk grep -n 'IUSE=' dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild
   19 │ IUSE="+cron +pdf +trivy +grype +depcheck"
   $ rtk grep -n 'app-vuln/' dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild
   27 │ 	trivy? ( app-vuln/trivy )
   28 │ 	grype? ( app-vuln/grype )
   29 │ 	depcheck? ( app-vuln/dependency-check )
   ```
   ⇒ three of the four scanner engines are gated; `osv` is absent from both `IUSE` and `RDEPEND`.

2. Confirm the upstream code invokes the binary and defaults the engine ON.
   ```
   $ rtk grep -n 'osv' /storage/home/haven/projects/vuln-scanner/src/vuln_scanner/orchestrator.py
   422:        if "osv" in shard.get("scanners", []) and self.config.get("scanners", {}).get("osv", True):
   423:            cmd = ["osv-scanner", "--format", "json", "--experimental-all-packages", path]
   ```
   ⇒ the engine is consulted by default (`.get("osv", True)`) and the binary is invoked by absolute command name.

3. Confirm the overlay ships the package that would satisfy the dependency.
   ```
   $ rtk ls app-vuln/
   dependency-check/  gitleaks/  grype/  osv-scanner/  semgrep/  skillspector/  trivy/
   ```
   ⇒ `app-vuln/osv-scanner` is already packaged here; only the dependency expression is missing.

4. Confirm the binary on this host comes from a *separate* atom, i.e. it is not a dependency of `dev-util/vuln-scanner`.
   ```
   $ ls -d /var/db/pkg/dev-util/vuln-scanner-* /var/db/pkg/app-vuln/osv-scanner-*
   /var/db/pkg/app-vuln/osv-scanner-2.5.1
   ```
   ⇒ `dev-util/vuln-scanner` is **not installed** here; the osv binary is present only because `app-vuln/osv-scanner` was installed independently. The two packages have no dependency edge.

5. Confirm nothing in the overlay declares the edge either (the engine would have no way to pull it in).
   ```
   $ rtk grep -rn 'app-vuln/osv-scanner' --include='*.ebuild' .
   (no hits outside app-vuln/osv-scanner itself)
   ```

6. Confirm the failure mode is silent. With `osv-scanner` removed from `PATH`, the upstream orchestrator writes the child's stderr to a per-invocation log file and never surfaces it, then logs a clean completion.
   ```
   $ rtk grep -n 'def _exec_streaming' -A 48 /storage/home/haven/projects/vuln-scanner/src/vuln_scanner/orchestrator.py
   369-371:  except Exception as e:
                 self.log.error("[%s] Failed: %s", tag, e)
                 return None
   ```
   ⇒ a missing binary becomes `None`, the engine contributes zero findings, and the run reports success.

7. Confirm the `osv` engine is not documented in the shipped example configuration either (the third instance of the same omission).
   ```
   $ rtk grep -n -A 6 '\[scanners\]' /storage/home/haven/projects/vuln-scanner/config.toml.example
   [scanners]
   trivy = true
   grype = true
   dependency_check = true
   ```
   ⇒ no `osv` key. (Owned by the upstream sibling change `declare-scanner-engine-dependencies`; recorded here so the three omissions are not fixed piecemeal in three repos.)

## Expected vs Actual

**Expected:** Every external binary a package executes at runtime is either declared as a dependency of that package, or the package does not execute it. Because the `osv` engine defaults to enabled upstream, the dependency must be expressed with a default that preserves today's runtime behaviour.

**Actual:** Five separate omissions, each independently sufficient to produce a silently degraded scan:

1. **The dependency is not declared.** `dev-util/vuln-scanner` has no `app-vuln/osv-scanner` in `RDEPEND`, while it declares `trivy`, `grype` and `dependency-check` — so the omission is inconsistent with the ebuild's own established pattern, not a deliberate design.
2. **There is no USE flag for it.** `IUSE` has no `osv` (or `security`) flag, so an operator cannot express "I do not want the osv engine", and the upstream `.get("osv", True)` default cannot be mirrored in the package metadata.
3. **The engine's availability therefore depends on an unrelated atom.** The binary is present on this host only because `app-vuln/osv-scanner` was installed separately. `emerge --unmerge app-vuln/osv-scanner` would leave `dev-util/vuln-scanner` fully "satisfied" by the package manager while removing a binary it executes.
4. **The failure is silent.** The upstream orchestrator swallows the missing binary and reports a clean run; there is no error, no warning, and no non-zero exit. The scanner would report zero findings for a class of vulnerability it simply never looked for.
5. **The omission is triple-recorded and hidden in three places** — the ebuild `IUSE`, the ebuild `RDEPEND`, and the upstream `config.toml.example` `[scanners]` block. Fixing only the ebuild leaves the upstream defaults able to enable an engine the package does not guarantee.

**Severity.** Not an active compromise on any host today (the binary is present here, and no `osv` findings have been produced by this path anyway — see the note below). This is a **latent availability and correctness defect** in the packaging: the correct state of the world today is accidental, and the estate has no mechanism that would notice its loss.

> ### Note — a second, independent defect in the same engine
> The upstream invocation at `orchestrator.py:423` is `["osv-scanner", "--format", "json", "--experimental-all-packages", path]`. The installed osv-scanner is **2.5.1**, whose CLI is subcommand-based and which has **no `--experimental-all-packages` flag** (the v2 equivalent is `--all-packages`). The command therefore fails on every host running osv-scanner ≥ 2.x, and the stderr is discarded to a log file. Verified on this host:
> ```
> $ osv-scanner --format json --experimental-all-packages /etc/hostname
> Incorrect Usage: flag provided but not defined: -experimental-all-packages
> ```
> That defect belongs to the upstream repository and is owned by the sibling change `declare-scanner-engine-dependencies` in `/storage/home/haven/projects/vuln-scanner`. It is recorded here only so the two are not conflated: **declaring the dependency does not make the engine work.** This change fixes the packaging; the sibling fixes the invocation and the exit-code contract.
>
> ### Note — observed but out of scope
> `PYTHON_COMPAT=( python3_{11..14} )` at line 7 deviates from this overlay's documented cap of `python3_{12..14}`. The deviation is downwards (it includes `python3_11`), so it is not the `python3_15` rejection the AGENTS.md gotcha describes, and it is a separate concern from the engine dependency. Recorded for a separate change; not fixed here.
>
> `dev-python/apprise` in `RDEPEND` becomes unnecessary once the upstream sibling `remove-dead-notification-config` lands. Cross-referenced, not fixed here.
