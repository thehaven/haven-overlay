## Hypothesis

The `osv` engine was never declared because the upstream integration that introduced it was only half-landed: the engine's *code* was added to the orchestrator, but the *packaging* side (a USE flag and a dependency edge in the overlay's ebuild) was written as a separate plan step that never reached the overlay. The prediction is falsifiable in one step — if the omission were deliberate, the ebuild would either gate the engine off by default (so the absent binary is never referenced) or the upstream would not enable it by default. **Both are false**: the ebuild has no flag at all, and upstream defaults the engine on with `.get("osv", True)`.

A second hypothesis is that the omission is deliberate because the osv engine is considered optional and best-effort — the same way `dependency-check` is gated behind `+depcheck`. **This is falsifiable too**: `dependency-check` is gated behind a USE flag *and* has a `RDEPEND` edge. The osv engine has neither. The pattern exists; osv simply is not in it.

## Evidence

**E1 — The ebuild gates three engines and omits the fourth.**
`dev-util/vuln-scanner/vuln-scanner-0.2.0.ebuild:19`
```
IUSE="+cron +pdf +trivy +grype +depcheck"
```
lines 27–29 of the same file:
```
	trivy? ( app-vuln/trivy )
	grype? ( app-vuln/grype )
	depcheck? ( app-vuln/dependency-check )
```
The `? ( )` form is the established pattern for "this engine needs this package". `osv` appears in neither list. The pattern is present and osv is outside it.

**E2 — The upstream engine defaults to enabled.**
`/storage/home/haven/projects/vuln-scanner/src/vuln_scanner/orchestrator.py:422`
```python
if "osv" in shard.get("scanners", []) and self.config.get("scanners", {}).get("osv", True):
    cmd = ["osv-scanner", "--format", "json", "--experimental-all-packages", path]
```
`self.config.get("scanners", {}).get("osv", True)` — the default is `True`, so the engine is consulted whenever a shard requests it, regardless of configuration.

**E3 — The engine set is config-driven, so the omission is invisible at build time.**
The same line shows the two-part predicate: the shard must list `"osv"` in its `scanners` array **and** the global `[scanners]` map must not disable it. Nothing in the package metadata constrains either. The installed `config.toml` on this host has no `[notifications]` block, and the shipped `config.toml.example` has no `[scanners] osv` key at all (E6) — so on a stock install the engine is reachable only via a hand-written shard that names it.

**E4 — The binary on this host comes from a separate atom.**
```
$ ls -d /var/db/pkg/dev-python/../dev-util/vuln-scanner-* /var/db/pkg/app-vuln/osv-scanner-*
/var/db/pkg/app-vuln/osv-scanner-2.5.1
```
`dev-util/vuln-scanner` is not installed on this host at all; `app-vuln/osv-scanner-2.5.1` is. There is no dependency edge between them, by construction.

**E5 — The failure path is silent.**
`orchestrator.py:325-372`, `_exec_streaming`:
```python
    except Exception as e:
        self.log.error("[%s] Failed: %s", tag, e)
        return None
```
and the call site at 426:
```python
    if out: self._parse_osv(out, results["osv"], seen["osv"], path)
```
A missing binary produces `FileNotFoundError` → caught → `None` → `if out:` is False → the engine contributes nothing and is indistinguishable from an engine that ran and found nothing. The child's stderr is written to `{tag}.stderr.log` and never read back.

**E6 — The same omission exists in the upstream example configuration.**
```
$ rtk grep -n -A 6 '\[scanners\]' config.toml.example
[scanners]
trivy = true
grype = true
dependency_check = true
```
No `osv` key. Three omissions of one fact, in three repositories.

**E7 — The dependency is already available in the overlay.**
`app-vuln/osv-scanner/` exists with ebuilds `1.9.1 2.3.8 2.4.0 2.5.0 2.5.1 2.6.0 2.7.0`. The fix needs no new package — only an edge.

**E8 — The original plan for this integration is recoverable and shows the omission was planned but never executed.**
The vault note `Inbox/AI-drafts/20260523-plan-synergy-implementation.md` (7-task plan, 2026-05-23) names the exact step:
> **T3** modular `security` USE flag on both ebuilds (`IUSE="security"`, `RDEPEND="security? ( app-vuln/osv-scanner )"`)

T1 (package `app-vuln/osv-scanner`) **landed** — E7. T2 (`_parse_osv` in the orchestrator) **landed** — E2. T3 **did not land**. The ebuild still carries no `security` flag and no osv dependency. This is a plan step that was written, agreed, and never executed — not a design decision.

**E9 — Nothing in the overlay declares the edge elsewhere.**
```
$ rtk grep -rn 'app-vuln/osv-scanner' --include='*.ebuild' .
(no hits outside app-vuln/osv-scanner itself)
```
No other package pulls it in on the scanner's behalf.

**E10 — The engine is additionally broken upstream, which bounds what this fix can promise.**
Verified on this host: osv-scanner is 2.5.1 and rejects `--experimental-all-packages`; the v2 equivalent is `--all-packages` under the mandatory `scan source` subcommand. So even with the dependency correctly declared, the engine produces no findings today. That defect is owned by the upstream sibling change `declare-scanner-engine-dependencies`.

## Root Cause

The `osv` scanner engine was integrated into vuln-scanner's *runtime* (the orchestrator invokes `osv-scanner` and enables it by default) without ever being integrated into the *packaging* — the overlay ebuild never gained a USE flag or a `RDEPEND` edge for `app-vuln/osv-scanner`, so the binary's presence is an accident of some unrelated atom having been installed rather than a property of `dev-util/vuln-scanner`.

## Blast Radius

**Affected**
- `dev-util/vuln-scanner` on every host that installs it. Any host where `app-vuln/osv-scanner` is not separately present has a scanner that silently omits an engine and reports success.
- Any future host provisioned by a declarative profile that installs only the scanner — the osv engine will be absent with no dependency error.
- `emerge --unmerge app-vuln/osv-scanner` on a host that has it: the package manager reports the scanner as fully satisfied while removing a binary it executes.
- The scan *reports* on such hosts: they are complete and internally consistent, so nothing downstream can tell the difference. `ebuild-updater`'s `get_latest_vulnerabilities` (`src/ebuild_updater/discover.py:800`, called `src/ebuild_updater/pipeline.py:1025` with `report_dir = Path("/var/log/security-scans")` at `pipeline.py:1017`) consumes those reports as evidence that a package was checked.

**Risks introduced by the fix**
- Adding the dependency pulls `app-vuln/osv-scanner` (a Go binary, ~61.6 MB per copy) onto every host that installs the scanner. This is a real cost and must be stated, not hidden. It is the correct cost: the engine already runs by default, so the binary is already in use wherever it is reached.
- Gating the engine behind a USE flag whose default differs from the upstream default would change runtime behaviour. The fix must default the flag **on**, matching `.get("osv", True)`, or the package would silently stop exercising an engine it previously exercised.
- An operator who disables the flag must also disable the engine in the configuration, or the upstream sibling will (correctly) report the engine as failed. That coupling must be documented in the ebuild, not left to be discovered.

**Out of scope**
- The upstream invocation defect and the exit-code contract (`--experimental-all-packages`, `scan source`, findings discarded on exit 1) — owned by `declare-scanner-engine-dependencies` in `/storage/home/haven/projects/vuln-scanner`.
- Making a missing engine fail loudly upstream — same sibling.
- The `dev-python/apprise` dependency, which becomes dead once `remove-dead-notification-config` lands upstream.
- `PYTHON_COMPAT=( python3_{11..14} )` versus the estate's `python3_{12..14}` cap.
- The USE flag *name*: the 2026-05-23 plan said `security`, but this ebuild's existing engine flags are named after the engines themselves (`trivy`, `grype`, `depcheck`). `osv` matches the local convention; `security` would be a new, broader concept. The decision is recorded in `tasks.md` and `plan.md`.
