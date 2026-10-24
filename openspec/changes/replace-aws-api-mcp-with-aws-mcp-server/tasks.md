# Tasks

Each task states how to verify completion. Groups land their own tests and documentation; groups 6
and 7 are integration-only. Every verification states what a **negative** result would mean, so a
passing check is evidence rather than an absence of output.

## 1. Package the successor

- [x] 1.1 Add `dev-util/mcp-proxy-for-aws/mcp-proxy-for-aws-1.7.0.ebuild` — `EAPI=8`,
  `PYPI_PN="mcp-proxy-for-aws"`, `DISTUTILS_USE_PEP517=hatchling`,
  `PYTHON_COMPAT=( python3_{12..14} )`, `inherit distutils-r1 pypi`, `HOMEPAGE` pointing at
  `https://github.com/aws/mcp-proxy-for-aws`, `LICENSE="Apache-2.0"`, `SLOT="0"`,
  `KEYWORDS="~amd64"`; verify `ebuild dev-util/mcp-proxy-for-aws` parses

  (DONE 2026-10-24 — ebuild + `metadata.xml` written. `ebuild ... info` reaches
  `pkg_info()` and reports "pkg_info() is not defined", proving it parses. Note `ebuild <file>
  --info` is invalid syntax; the subcommand is `info` without dashes. `ebuild <file> depend` is
  broken on this host with `TypeError: returnproc or returnpid must be True for depend phase` —
  a portage API defect, unrelated to the ebuild.)
- [x] 1.2 Declare `RDEPEND` faithful to the upstream wheel: `boto3>=1.41.0`,
  `botocore[crt]>=1.41.0`, `fastmcp>=3.2,<3.5`, `httpx>=0.27.1,<1.0`; verify the `[crt]` extra is
  satisfiable by the Gentoo-tree `dev-python/botocore` atom, and that `fastmcp-3.4.7` is the only
  overlay version satisfying the upstream range

  (DONE 2026-10-24 — the `[crt]` extra is **NOT satisfiable**, and the divergence is recorded
  rather than silently dropped. Installed `botocore-1.43.86` declares
  `Requires-Dist: awscrt==0.36.0; extra == "crt"`; `awscrt` has no ebuild in the Gentoo tree or in
  this overlay, and the Gentoo-tree `dev-python/botocore` ebuilds have no IUSE line and no `crt`
  USE flag. The proxy's own source contains zero `awscrt` / `botocore.crt` / `CRT` hits, so the
  extra is not exercised — declaring it would make the atom unsatisfiable on every host. The ebuild
  declares `botocore` without the extra and records why; packaging `awscrt` (a Rust-backed build)
  is a separate follow-up. `fastmcp-3.4.7` is confirmed the only overlay version satisfying
  upstream's `>=3.2,<3.5`, and `emerge --pretend` confirms it is what resolves.)
- [x] 1.3 **Do not** copy the retired ebuild's `src_prepare()` backend fix-up. Unpack the 1.7.0
  sdist, read its `pyproject.toml`, and assert its declared `build-backend` is
  `hatchling.build`; only add a `sed` if that sdist proves it necessary. Verify the ebuild carries
  no `uv_build` rewrite

  (DONE 2026-10-24 — the 1.7.0 sdist was unpacked at `/tmp/mpfa/mcp_proxy_for_aws-1.7.0/` and
  its `pyproject.toml` read: line 91 `requires = ["hatchling"]`, line 92
  `build-backend = "hatchling.build"`. No `sed` was added and no `src_prepare()` override exists;
  the decision is recorded in an ebuild comment.)
- [x] 1.4 Implement `python_test()` that imports `mcp_proxy_for_aws.server` — the console-script
  target — and asserts `/usr/bin/mcp-proxy-for-aws` exists. The generated `${PN//-/_}` check is
  insufficient: upstream ships no `mcp_proxy_for_aws/__init__.py`, so that import succeeds as a
  namespace package even when the module is broken. Verify the check **fails** against a directory
  with no importable module (negative control) before trusting a pass

  (DONE 2026-10-24 — `python_test()` imports `mcp_proxy_for_aws.server` and asserts
  `/usr/bin/mcp-proxy-for-aws` is executable, `die`ing on either failure. **Rationale corrected:**
  the 1.7.0 sdist DOES ship `mcp_proxy_for_aws/__init__.py` (1025 B, `__version__` read from
  `importlib.metadata`), so the "namespace-package false pass" premise is wrong for this version.
  The check is still right — it asserts the console-script TARGET rather than the distribution name,
  and asserts the script artefact the native path depends on. Negative control run: on this host
  `import mcp_proxy_for_aws.server` fails and `/usr/bin/mcp-proxy-for-aws` is absent, so both
  branches would `die` as intended.)
- [x] 1.5 Implement `pkg_postinst()` emitting the successor client snippet for Gemini CLI, Claude
  Desktop and OpenCode using the **native path** `/usr/bin/mcp-proxy-for-aws` + the managed endpoint
  URL + `--metadata AWS_REGION=` — not a `uvx` runtime resolution. Verify
  `rtk grep -c 'awslabs.aws-api-mcp-server' <ebuild>` is `0` and
  `rtk grep -c '/usr/bin/mcp-proxy-for-aws' <ebuild>` is non-zero

  (DONE 2026-10-24 — `pkg_postinst()` emits the MIGRATION NOTICE (tool renames, removals, the
  eight new tools, "delete the old entry", "remove hardcoded call_aws references" + the upstream
  agent-rule URL), the two-independent-Regions warning with a deliberately invalid
  `AWS_REGION=REPLACE_WITH_OPERATIONS_REGION` placeholder, the accurate credential position
  (SigV4 signing stays local — explicitly NOT "zero credential exposure"), and the native-path
  client snippet for all three clients. Verified: `grep -c 'awslabs.aws-api-mcp-server'` = **0**,
  `grep -c '/usr/bin/mcp-proxy-for-aws'` = 6, `grep -cE 'uvx|@latest'` = **0**, all three client
  paths present. The notice names the retired PACKAGE rather than the retired command string, so
  the retired-command check stays exactly 0 while the instruction stays unambiguous.)
- [x] 1.6 Record the upstream sibling-wrapper constraint in the ebuild comment: the separate
  `mcp-proxy-for-aws-cli` wrapper pins `mcp-proxy-for-aws` to its own version and must move in
  lockstep, so a bump of one without the other is a defect

  (DONE 2026-10-24 — recorded in the ebuild comment block: `mcp-proxy-for-aws-cli` pins
  `mcp-proxy-for-aws` to its own version and the two must move in lockstep.)
- [x] 1.7 Add `scripts/tests/test_mcp_proxy_for_aws_ebuild.py` following
  `test_litellm_ebuild.py` / `test_grafonnet_ebuild.py` / `test_headroom_ai_ebuild.py`; verify
  `pytest scripts/tests/` passes with the new file included and that the suite's recorded baseline
  gains no new failures

  (DONE 2026-10-24 — `scripts/tests/test_mcp_proxy_for_aws_ebuild.py` written with 8 tests:
  version on PyPI, PYTHON_COMPAT inside upstream `requires_python`, native path present and no
  `uvx`/`npx`/`@latest`, retired command absent, fastmcp upper bound declared, `python_test()`
  asserts the console-script target, no inherited backend rewrite, `metadata.xml` present.
  `pytest -p no:hydra_pytest scripts/tests/test_mcp_proxy_for_aws_ebuild.py` → **8 passed**.
  Negative control: the same file run against a decoy ebuild carrying every defect → **0 passed,
  8 failed** — the suite is proven capable of failing, so the pass is evidence. The
  `-p no:hydra_pytest` flag is required on this host (the known portage `hydra-core-1.4.0_rc2` /
  `omegaconf-2.4.0` pairing defect). Baseline comparison against the rest of `scripts/tests/` is
  task 7.2.)

## 2. Resolve the dependency set — the gate

This group runs **only after group 1 has landed**. A dry-run against an atom with no ebuild in the
tree reports "no ebuilds to satisfy" — that is *not checked*, never *clean*.

- [ ] 2.1 Run `emerge --pretend --ask=no dev-util/mcp-proxy-for-aws` and confirm the resolved set
  selects `fastmcp-3.4.7`; verify the output contains **no** `fastmcp-4.x`, no unsatisfiable
  constraint, and — as a negative control — that the same command against an atom with no ebuild
  is recognised as vacuous and is **not** recorded as a pass
- [ ] 2.2 Run `emerge --pretend --ask=no dev-util/mcp-meta` with `USE=aws` and diff the resolved
  dependency set against the current one; verify the **only** difference is the AWS MCP atom and
  that all fastmcp dependents remain satisfiable. The successor's `fastmcp>=3.2,<3.5` is already
  the overlay's effective range, so **no fastmcp version change is expected** — any fastmcp change
  in the diff is a finding, not a success
- [ ] 2.3 Verify the endpoint is reachable from a representative host before cutover — probe
  `https://aws-mcp.us-east-1.api.aws/mcp` — and record the result in the change's notes

## 3. Retire the old package and repoint the meta-package

- [ ] 3.1 Add `dev-util/mcp-server-aws` to `profiles/package.mask` under the existing
  "Dead upstream" block with a dated reason and an **open-ended `>=` range**, matching the
  overlay's recorded mask convention; verify the ebuild file is **still present** on disk and that
  the mask line survives a regeneration of the file
- [ ] 3.2 On every host that carries it, unmerge the retired package
  (`emerge --unmerge dev-util/mcp-server-aws`) so no end-of-life server remains installed behind
  the mask; verify `qlist -Iv mcp-server-aws` is empty afterwards. Reversibility is preserved at
  the **mask** level — removing one line and re-emerging restores it — not at the installed level
- [ ] 3.3 Bump `dev-util/mcp-meta` with the `aws` USE flag repointed from
  `dev-util/mcp-server-aws` to `dev-util/mcp-proxy-for-aws`; derive the new version from the
  newest in-tree version and **leave that version's ebuild intact**; verify the new version's
  RDEPEND maps `aws? ( dev-util/mcp-proxy-for-aws )`
- [ ] 3.4 Make the semantic change loud: the new meta version's note records that `USE=aws` now
  selects a **managed remote** server rather than a local one, and the successor's `pkg_postinst`
  carries a migration notice. Verify both statements are present in the built artefacts
- [ ] 3.5 Regenerate the overlay Manifest for the new atom **in a scratch copy of the tree**, never
  in the validated checkout — `ebuild <file> manifest` writes the file. Treat
  `metadata/md5-cache/` as **reported, not enforced**: the webhost regenerates it in bulk, so a
  pipeline that gated on it would gate on a condition the project has declared out of scope

## 4. Update the mesh and the fastmcp consumers

- [ ] 4.1 Give the **installed stable** `app-admin/mcp-mesh` an explicit resolve-time bound:
  `dev-python/mcp` is currently unbounded and survives only because
  `profiles/package.mask` masks `>=dev-python/mcp-2.0.0`, which bites at install time, not at
  resolve time. Add `<dev-python/mcp-2` to `app-admin/mcp-mesh-0.22.1.ebuild` only — the newest
  stable — leaving the retired versions untouched so the fix propagates to future bumps
- [ ] 4.2 Extend `scripts/tests/test_mcp_pin.py` with a **current-version** assertion for the
  packages named in 4.1. The existing guard is text-based and per-ebuild across every version, so
  adding `app-admin/mcp-mesh` to `FASTMCP_PACKAGES` wholesale would demand the bound in all eight
  ebuilds and rewrite history. Verify the new assertion **fails** when the bound is removed
- [ ] 4.3 Add a guard that every fastmcp consumer's **current** version declares
  `<dev-python/fastmcp-4`. No overlay ebuild upper-bounds fastmcp below 4 today — fourteen are
  unbounded and the rest are minimum-only — so the single `>=dev-python/fastmcp-4.0.0` mask line
  is the only thing holding the fleet below fastmcp 4.x. The successor is the first ebuild to
  carry the bound in its own dependency declaration. Verify the guard reports the current
  unguarded consumers as a recorded baseline rather than failing the suite
- [ ] 4.4 Ship a worked registry example for the managed AWS MCP Server **from the overlay's own
  `files/` directory**, installed alongside the `app-admin/mcp-mesh` template. The upstream
  `registry.yaml.example` lives in the mcp-mesh repository and would diverge on every bump, so the
  overlay carries its own copy rather than forking upstream. Verify the example parses as YAML and
  declares the native path + endpoint + `--metadata AWS_REGION=`
- [ ] 4.5 Record an upstream contribution as a follow-up task: the worked example should land in the
  mcp-mesh repository so the overlay can ship it natively once upstream adopts it

## 5. Register the server in the fleet mesh

- [ ] 5.1 After the successor is emerged, add the AWS MCP Server to the fleet registry
  `/etc/mcp-forge/registry.yaml` under `servers:` — **available but unused**. It is referenced by
  no profile, so mcp-mesh's just-in-time mounting never activates it. Verify the entry parses,
  that the registry precedence rules still hold (`--registry` flag > per-user > system-wide), and
  that the previous registry state was backed up before the edit
- [ ] 5.2 Verify `mcp-mesh` and `mcp-forge` still work after the registry edit — `mcp-mesh doctor`,
  `curl -sS http://127.0.0.1:7780/health` and `curl -sS http://127.0.0.1:7780/ready` — and that
  `app-admin/mcp-forge` still imports and runs its profile orchestrator
- [ ] 5.3 Confirm no profile references the new server, so the fleet's active tool surface is
  unchanged by this change

## 6. Document the migration

- [ ] 6.1 Add the configuration-contract mapping table to the overlay documentation — one row per
  old setting, giving the successor equivalent, including an explicit **"no equivalent"** row for
  each of the nine settings that do not carry over (`AWS_API_MCP_WORKING_DIR`,
  `AWS_API_MCP_ALLOW_UNRESTRICTED_LOCAL_FILE_ACCESS`, `AWS_API_MCP_AGENT_SCRIPTS_DIR`,
  `AWS_API_MCP_TRANSPORT`/`_HOST`/`_PORT`, `AUTH_TYPE`/`AUTH_ISSUER`/`AUTH_JWKS_URI`,
  `AWS_API_MCP_TELEMETRY`); verify every old setting in the retired ebuild appears in the table
- [ ] 6.2 Document the tool-surface change — `call_aws` → `aws___call_aws`, `suggest_aws_commands`
  and `get_execution_plan` removed, the eight new tools listed — and the instruction to **remove**
  hardcoded `call_aws` references from skills, context files, prompts and steering documents,
  pointing at the upstream AWS agent rule; verify the upstream rule URL is present and resolves
- [ ] 6.3 Document the two independent Regions — the endpoint URL Region (where the managed server
  runs) versus `--metadata AWS_REGION` (the operations Region), that omitting the latter defaults
  operations to `us-east-1`, and that the old entry must be **deleted** rather than left alongside
  the new one; verify all three statements appear
- [ ] 6.4 Document that the **packaged atom is the pin** — client configuration names the native
  path and the endpoint, and never resolves the proxy through a runtime package resolver. Verify
  `rtk grep -rn 'mcp-proxy-for-aws@latest' .` returns nothing and that no emitted snippet contains
  `uvx`
- [ ] 6.5 Document the credential position accurately: API execution moves AWS-side, but **SigV4
  signing stays local** and the proxy still uses the local credential chain. Verify the
  documentation does not claim "zero credential exposure"

## 7. Overlay consistency

- [ ] 7.1 Verify the overlay carries no second ebuild for either upstream:
  `ls -d */mcp-proxy-for-aws`, `rtk grep -rl 'aws/mcp-proxy-for-aws' --include='*.ebuild' .` and
  `rtk grep -rl 'mcp-proxy-for-aws' metadata` — the first may match only the new atom, the other
  two must return nothing else
- [ ] 7.2 Run the full overlay test suite `pytest scripts/tests/` with an **explicit timeout** and
  verify the result is *no NEW failures against the recorded baseline* — not *zero failures*; a
  gate demanding zero would be red from its first run and would train the operator to ignore it.
  Any skipped or hanging test must be recorded in the output, never silently dropped
- [ ] 7.3 Run `ebuild dev-util/mcp-proxy-for-aws clean` and a `--pretend` emerge; verify no
  Portage warnings and that the manifest is consistent. Do **not** gate on a repo-wide `pkgcheck`
  finding count — pkgcheck 0.10.39 does not know portage's `network-sandbox` feature and flags
  correct ebuilds as wrong

## 8. Integration verification

- [ ] 8.1 On a host with the successor installed, confirm the MCP server exposes `aws___call_aws`
  and that `call_aws` and `suggest_aws_commands` are **absent** from the tool list
- [ ] 8.2 Execute one read-only AWS call through the successor and confirm the operation lands in
  the intended operations Region (not the endpoint Region, and not the `us-east-1` default)
- [ ] 8.3 Confirm every other installed `dev-util/mcp-server-*` package still starts and serves its
  tools, and that no fastmcp version changed on the host

## Workflow follow-up

- Commit only after explicit user approval (overlay AGENTS.md). Conventional-commit style:
  `dev-util/mcp-proxy-for-aws: add package for the managed AWS MCP Server` and
  `dev-util/mcp-meta: repoint aws flag to the managed AWS MCP Server`.
- Archive the change after the project's review requirements are satisfied.
- Client-configuration changes on each host (including this host's
  `~/.config/opencode/opencode.json`) are separate repositories and need their own approval; they
  are not performed by this change.
