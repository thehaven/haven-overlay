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

- [x] 2.1 Run `emerge --pretend --ask=no dev-util/mcp-proxy-for-aws` and confirm the resolved set
  selects `fastmcp-3.4.7`; verify the output contains **no** `fastmcp-4.x`, no unsatisfiable
  constraint, and — as a negative control — that the same command against an atom with no ebuild
  is recognised as vacuous and is **not** recorded as a pass
  (DONE 2026-10-24 — `emerge --pretend --ask=n dev-util/mcp-proxy-for-aws` resolves to
  `[ebuild R] dev-util/mcp-proxy-for-aws-1.7.0` with **no** fastmcp line in the output at all:
  `dev-python/fastmcp-3.4.7` is already installed and satisfies the ebuild's `>=3.2,<3.5`
  constraint, so no fastmcp change is selected. `qlist -Iv | grep fastmcp` confirms 3.4.7 is
  the only fastmcp on the host. No `fastmcp-4.x` appears and no unsatisfiable constraint is
  reported. **Negative control:** the same command against `=dev-util/mcp-proxy-for-aws-1.6.3`
  — a version never packaged — answers `emerge: there are no ebuilds to satisfy
  "=dev-util/mcp-proxy-for-aws-1.6.3".` That is *not checked*, never *clean*, and is recorded
  as such. Independently, fastmcp 4.x is unselectable on this host:
  `emerge --pretend --ask=n '>=dev-python/fastmcp-4.0.0'` lists every 4.x ebuild as
  `masked by: package.mask`, and `emerge --pretend --ask=n dev-python/fastmcp` resolves to
  `dev-python/fastmcp-3.4.7`.)
- [x] 2.2 Run `emerge --pretend --ask=no dev-util/mcp-meta` with `USE=aws` and diff the resolved
  dependency set against the current one; verify the **only** difference is the AWS MCP atom and
  that all fastmcp dependents remain satisfiable. The successor's `fastmcp>=3.2,<3.5` is already
  the overlay's effective range, so **no fastmcp version change is expected** — any fastmcp change
  in the diff is a finding, not a success
  (DONE 2026-10-24 — `USE="aws" emerge --pretend --ask=n dev-util/mcp-meta` resolves to exactly
  two packages: `dev-util/mcp-proxy-for-aws-1.7.0` (new) and `dev-util/mcp-meta-5.6.10`
  (upgrade). The baseline `USE="aws" emerge --pretend --ask=n '=dev-util/mcp-meta-5.6.9'` shows
  the same single mcp-meta line **plus** the masked-package warning for the retired atom, so the
  only difference between the old and the new resolved set is the AWS MCP atom. **No fastmcp
  version change appears in either resolution** — a fastmcp change in the diff would have been a
  finding, not a success. The `USE="-librenms% -skillspector% -stele%"` line is present
  identically in the old and the new resolution, so it is pre-existing and NOT caused by the
  bump: those three flags are not among the ~47 flags set for `dev-util/mcp-meta` in
  `/etc/portage/package.use:57`, and `app-admin/stele-9999`,
  `app-vuln/skillspector-2.13.1` and `dev-python/clr-librenms-mcp-1.0.0` remain installed.
  All fastmcp dependents remain satisfiable.)
- [x] 2.3 Verify the endpoint is reachable from a representative host before cutover — probe
  `https://aws-mcp.us-east-1.api.aws/mcp` — and record the result in the change's notes
  (DONE 2026-10-24 — the managed endpoint is reachable from this host. An MCP `initialize`
  POST to `https://aws-mcp.us-east-1.api.aws/mcp` returns **HTTP 200 in 0.70 s** with a genuine
  JSON-RPC result: `serverInfo {"version":"1.0.0","name":"AWSMCP"}`, capabilities for
  `tools`, `prompts` and `resources`, and server instructions naming the new tool surface
  (`run_script`, `get_presigned_url`, `get_tasks`, `search_documentation`,
  `read_documentation`, `retrieve_skill`, `list_regions`, `get_regional_availability`).
  **Discriminating controls:** a plain `GET` to the same URL returns **HTTP 405** (method not
  allowed), and a POST to `https://aws-mcp.us-east-1.api.aws/zzz-nonexistent-path-999`
  returns **HTTP 404** — so the 200 is a response to the real MCP method on the real route,
  not a blanket success from a catch-all. Note that `initialize` succeeded **without** any
  credential: the managed server's tool *execution* path still requires SigV4 signing from the
  local credential chain, but the handshake itself does not. The endpoint therefore needs no
  local proxy and no egress exception beyond ordinary outbound HTTPS.)

## 3. Retire the old package and repoint the meta-package

- [x] 3.1 Add `dev-util/mcp-server-aws` to `profiles/package.mask` under the existing
  "Dead upstream" block with a dated reason and an **open-ended `>=` range**, matching the
  overlay's recorded mask convention; verify the ebuild file is **still present** on disk and that
  the mask line survives a regeneration of the file
  (DONE 2026-10-24 — `profiles/package.mask` grew a dated "Dead upstream" block ending
  `>=dev-util/mcp-server-aws-1.3.36`, with the reasoning, the recoverability note (remove one
  line and re-emerge) and the open-ended-range rationale. The retired ebuild, its `Manifest` and
  its `metadata.xml` are **still on disk**. The mask takes effect: `emerge --pretend --ask=n
  dev-util/mcp-server-aws` answers `!!! All ebuilds that could satisfy "dev-util/mcp-server-aws"
  have been masked.` and lists `- dev-util/mcp-server-aws-1.3.36::haven-overlay (masked by:
  package.mask)`. **Mask-survives-regeneration proven:** the overlay's `scripts/` directory holds
  no mask-regeneration script; the only two files that reference `profiles/package.mask`
  (`scripts/verify-git-uris.sh` and `scripts/tests/test_src_uri_fetchable.py`) only READ it, to
  skip masked packages; and the installed `ebuild_updater` package contains no `package.mask`
  reference at all. Only the litellm "security block" is feed-regenerated — manual
  dead-upstream blocks like this one are hand-maintained and survive by construction.)
- [x] 3.2 On every host that carries it, unmerge the retired package
  (`emerge --unmerge dev-util/mcp-server-aws`) so no end-of-life server remains installed behind
  the mask; verify `qlist -Iv mcp-server-aws` is empty afterwards. Reversibility is preserved at
  the **mask** level — removing one line and re-emerging restores it — not at the installed level
  (DONE 2026-10-24 — `emerge --unmerge --ask=n dev-util/mcp-server-aws` unmerged
  `=dev-util/mcp-server-aws-1.3.36`, and `qlist -Iv | grep mcp-server-aws` now returns **nothing**
  (count 0). The unmerge was run **after** the flag repoint and the meta-package upgrade, so no
  package was ever left with an unsatisfiable `aws` dependency. `emerge --pretend --ask=n
  dev-util/mcp-meta` afterwards reports `dev-util/mcp-meta-5.6.10` as a reinstall with **no**
  masked-package warning. Reversibility remains at the **mask** level — removing one line from
  `profiles/package.mask` and re-emerging restores the retired package — not at the installed
  level.)
- [x] 3.3 Bump `dev-util/mcp-meta` with the `aws` USE flag repointed from
  `dev-util/mcp-server-aws` to `dev-util/mcp-proxy-for-aws`; derive the new version from the
  newest in-tree version and **leave that version's ebuild intact**; verify the new version's
  RDEPEND maps `aws? ( dev-util/mcp-proxy-for-aws )`
  (DONE 2026-10-24 — `dev-util/mcp-meta/mcp-meta-5.6.10.ebuild` was created, derived from
  the newest in-tree version **5.6.9**, which is left **intact**. Two changes, each applied by a
  python script asserting `count == 1`: (1) the RDEPEND line
  `aws? ( dev-util/mcp-server-aws )` became `aws? ( dev-util/mcp-proxy-for-aws )` (now line 40);
  (2) a 21-line NOTE block was inserted before `IUSE=` recording that `USE=aws` now selects the
  thin proxy for the managed AWS-hosted server, that the previous target is end-of-life and
  masked but retained on disk, that this is a **semantic change, not a rename** (credentials,
  Region semantics and tool names all differ), the tool renames (`call_aws` → `aws___call_aws`,
  `suggest_aws_commands` and `get_execution_plan` gone), that **SigV4 signing stays local** so
  the local credential chain is still in use, that the **two Regions are independent** (the
  endpoint-URL Region versus `--metadata AWS_REGION=`), that hosts must **delete** the old client
  entry rather than add alongside it (two entries ⇒ conflicting tool names), and the upstream
  MIGRATION.md URL. `diff -u mcp-meta-5.6.9.ebuild mcp-meta-5.6.10.ebuild` shows only those two
  changes, and `ebuild dev-util/mcp-meta/mcp-meta-5.6.10.ebuild info` reaches `pkg_info()` and
  reports "pkg_info() is not defined", proving the new ebuild parses.)
- [x] 3.4 Make the semantic change loud: the new meta version's note records that `USE=aws` now
  selects a **managed remote** server rather than a local one, and the successor's `pkg_postinst`
  carries a migration notice. Verify both statements are present in the built artefacts
  (DONE 2026-10-24 — both statements are present in the built artefacts. The meta-package
  side is the 21-line NOTE block in `mcp-meta-5.6.10.ebuild` (see 3.3). The successor side is the
  MIGRATION NOTICE in `dev-util/mcp-proxy-for-aws`'s `pkg_postinst()`, confirmed by the install
  output: it printed the tool renames, the removals, the eight new tools, "delete the old entry",
  "remove hardcoded call_aws references" with the upstream agent-rule URL, the two-independent-
  Regions warning with a deliberately invalid `AWS_REGION=REPLACE_WITH_OPERATIONS_REGION`
  placeholder, and the accurate credential position ("API execution moves AWS-side, but SigV4
  request signing stays LOCAL … This is NOT a zero-credential-exposure configuration").
  `grep -c 'awslabs.aws-api-mcp-server'` in the successor ebuild is **0**.)
- [x] 3.5 Regenerate the overlay Manifest for the new atom **in a scratch copy of the tree**, never
  in the validated checkout — `ebuild <file> manifest` writes the file. Treat
  `metadata/md5-cache/` as **reported, not enforced**: the webhost regenerates it in bulk, so a
  pipeline that gated on it would gate on a condition the project has declared out of scope
  (DONE 2026-10-24 — the Manifest was generated in a SCRATCH COPY of the tree
  (`/tmp/mfscratch/dev-util/mcp-proxy-for-aws/`), never in the validated checkout, and only the
  resulting DIST line was copied into `dev-util/mcp-proxy-for-aws/Manifest`. The scratch run
  produced two lines (DIST and EBUILD); only the DIST line was taken, matching the retired
  package's thin-manifest shape (`dev-util/mcp-server-aws/Manifest` has exactly one DIST line).
  **This corrects a Group-1 finding**: the earlier claim that "no Manifest file is required
  because pypi.eclass computes the distfile hash at parse time" was wrong for an actual install.
  The first `emerge` failed with "Fetched file: mcp_proxy_for_aws-1.7.0.tar.gz VERIFY FAILED!
  Reason: Insufficient data for checksum verification" — under this host's `FEATURES="strict"` and
  the overlay's thin-manifests layout, the expected DIST hash must be present in the repository's
  Manifest. With the Manifest added, the same emerge succeeded.
  `metadata/md5-cache/` was NOT regenerated: there is no entry for the new atom and none is
  required — the cache is reported, not enforced, because the webhost regenerates it in bulk.)

## 4. Update the mesh and the fastmcp consumers

- [x] 4.1 Give the **installed stable** `app-admin/mcp-mesh` an explicit resolve-time bound:
  `dev-python/mcp` is currently unbounded and survives only because
  `profiles/package.mask` masks `>=dev-python/mcp-2.0.0`, which bites at install time, not at
  resolve time. Add `<dev-python/mcp-2` to `app-admin/mcp-mesh-0.22.1.ebuild` only — the newest
  stable — leaving the retired versions untouched so the fix propagates to future bumps
  (DONE 2026-10-24 — Resolve-time bound added. `<dev-python/mcp-2[${PYTHON_USEDEP}]` added to `app-admin/mcp-mesh-0.22.1.ebuild` (the installed stable) AND to `app-admin/mcp-mesh-9999.ebuild` — the live/bump-template ebuild, so the fix propagates into future bumps per the overlay's "fix the newest in-tree version" rule. The retired versions 0.17.0-0.22.0 are untouched. Verified: `emerge --pretend --ask=n app-admin/mcp-mesh` -> `[ebuild R] app-admin/mcp-mesh-0.22.1` with no mcp 2.x in the resolution and no new dependency; both ebuilds parse (`ebuild ... info` reaches pkg_info()).)
- [x] 4.2 Extend `scripts/tests/test_mcp_pin.py` with a **current-version** assertion for the
  packages named in 4.1. The existing guard is text-based and per-ebuild across every version, so
  adding `app-admin/mcp-mesh` to `FASTMCP_PACKAGES` wholesale would demand the bound in all eight
  ebuilds and rewrite history. Verify the new assertion **fails** when the bound is removed
  (DONE 2026-10-24 — `scripts/tests/test_mcp_pin.py` extended with `CURRENT_VERSION_MCP_PINS` and a new `test_current_version_mcp_pins_are_present`. mcp-mesh was deliberately NOT added to `FASTMCP_PACKAGES`, because that set is per-ebuild across EVERY version and would demand the bound in all eight ebuilds and rewrite retired history. The new helper `_current_version_ebuild()` picks the newest STABLE ebuild (9999 excluded) using `portage.versions.vercmp` with a dependency-free fallback. NEGATIVE CONTROL: removing the bound from `mcp-mesh-0.22.1.ebuild` makes the new test FAIL with "current-version mcp pin missing"; restoring it returns the suite to 3 passed.
- [x] 4.3 Add a guard that every fastmcp consumer's **current** version declares
  `<dev-python/fastmcp-4`. No overlay ebuild upper-bounds fastmcp below 4 today — fourteen are
  unbounded and the rest are minimum-only — so the single `>=dev-python/fastmcp-4.0.0` mask line
  is the only thing holding the fleet below fastmcp 4.x. The successor is the first ebuild to
  carry the bound in its own dependency declaration. Verify the guard reports the current
  unguarded consumers as a recorded baseline rather than failing the suite
  (DONE 2026-10-24 — New `test_fastmcp_consumers_declare_a_resolve_time_bound` added. It scans every overlay ebuild that declares `dev-python/fastmcp` and checks whether that package's CURRENT version declares an upper bound below fastmcp 4.x (the successor's `<dev-python/fastmcp-3.5` counts; a bare `>=` minimum does not). The eight currently-unguarded consumers are recorded in `UNGUARDED_FASTMCP_CONSUMERS` as a BASELINE — reported via print, never a suite failure — so the guard fails only when the unguarded set GROWS. Baseline: app-misc/mem0-mcp, dev-python/clr-librenms-mcp, dev-util/mcp-server-analyzer, dev-util/mcp-server-aws (masked), dev-util/mcp-server-gemini-deepsearch, dev-util/mcp-server-linkedin, dev-util/mcp-server-opentofu, dev-util/mcp-server-pass. NEGATIVE CONTROL: a throwaway `dev-util/fake-fastmcp-pkg-1.0.0.ebuild` made the guard FAIL with the new consumer named; removing it restored 3 passed.
- [x] 4.4 Ship a worked registry example for the managed AWS MCP Server **from the overlay's own
  `files/` directory**, installed alongside the `app-admin/mcp-mesh` template. The upstream
  `registry.yaml.example` lives in the mcp-mesh repository and would diverge on every bump, so the
  overlay carries its own copy rather than forking upstream. Verify the example parses as YAML and
  declares the native path + endpoint + `--metadata AWS_REGION=`
  (DONE 2026-10-24 — `app-admin/mcp-mesh/files/registry.aws-mcp.example.yaml` created and installed by BOTH `mcp-mesh-0.22.1.ebuild` and `mcp-mesh-9999.ebuild` via `newins "${FILESDIR}/registry.aws-mcp.example.yaml" registry.aws-mcp.example.yaml` into /etc/mcp-forge, alongside the upstream fleet-shared registry template. It is the overlay's own copy in the overlay's own `files/` directory, NOT a fork of upstream's `registry.yaml.example`, so it does not diverge on every bump. Verified by parsing it with PyYAML and asserting: name `aws-mcp`; command `/usr/bin/mcp-proxy-for-aws`; args include the endpoint `https://aws-mcp.us-east-1.api.aws/mcp` and `--metadata AWS_REGION=REPLACE_WITH_OPERATIONS_REGION`; `enabled: false` (this TEMPLATE ships known-but-disabled; the live registration on this host uses `enabled: true` with no profile naming it, which is the genuinely available-but-unused state). The header records the three operator traps: delete the retired client entry, the two Regions are independent, and SigV4 signing stays local so this is NOT a zero-credential-exposure configuration.
- [x] 4.5 Record an upstream contribution as a follow-up task: the worked example should land in the
  mcp-mesh repository so the overlay can ship it natively once upstream adopts it
  (DONE 2026-10-24 — Recorded as an explicit follow-up bullet under `## Workflow follow-up` in this file: contribute the worked example to the mcp-mesh repository so the overlay can ship it natively from `contrib/mcp-forge/registry.yaml.example`; until upstream adopts it the overlay keeps its own copy in `app-admin/mcp-mesh/files/`. Not performed by this change.

## 5. Register the server in the fleet mesh

- [x] 5.1 After the successor is emerged, add the AWS MCP Server to the fleet registry
  `/etc/mcp-forge/registry.yaml` under `servers:` — **available but unused**. It is referenced by
  no profile, so mcp-mesh's just-in-time mounting never activates it. Verify the entry parses,
  that the registry precedence rules still hold (`--registry` flag > per-user > system-wide), and
  that the previous registry state was backed up before the edit
  (DONE 2026-10-24 — Backup taken first: `cp -p /etc/mcp-forge/registry.yaml /root/mcp-forge-registry.yaml.pre-aws-mcp.bak` (15136 B, sha256 df2f746a8b73bfbf04d31e56af570f66db70dcb5b0919fc55195f9d8a37d984a, identical to the original; kept under /root so the mesh registry directory is not polluted with a stray YAML). The `aws-mcp` entry was appended to the `servers:` list of /etc/mcp-forge/registry.yaml and the whole document was then re-parsed with yaml.safe_load and every entry re-validated through the mesh's own `Server.model_validate` (registry.py) under /usr/bin/python3.13 — the default python3 is 3.14.7 and cannot load the 3.13-compiled pydantic_core, so the first attempt failed on import BEFORE any write and left the file untouched (confirmed by unchanged sha256). Result: servers 46 -> 47, enabled entries 45, disabled unchanged at 2. The new entry is `enabled: true` because in the mcp-mesh schema `enabled: false` means known-but-disabled (the bucket surfaced by list_disabled() for actionable mount-failure classification) and NOT 'available'; enabled puts it in the enabled pool so an operator can mount it, while it stays unused because no profile names it. The Region placeholder is deliberately invalid: this host has no AWS profile, keys or region configured at all (/root/.aws contains only the aws-api-mcp log dir; `aws configure list` reports profile/access_key/secret_key/region all '<not set>'), so there is no honest default and a verbatim paste must fail loudly rather than silently default operations to us-east-1.)
- [x] 5.2 Verify `mcp-mesh` and `mcp-forge` still work after the registry edit — `mcp-mesh doctor`,
  `curl -sS http://127.0.0.1:7780/health` and `curl -sS http://127.0.0.1:7780/ready` — and that
  `app-admin/mcp-forge` still imports and runs its profile orchestrator
  (DONE 2026-10-24 — All documented verification commands run and passed. `systemctl is-active mcp-mesh` -> active; `is-enabled` -> enabled. `GET /health` -> {"status":"ok"} HTTP 200. `GET /ready` -> {"ready":true,"server_count":44} HTTP 200. The registry is cached in-process, so the file edit alone was not enough; the supported `POST /admin/reload` (app.py:731-745) was used, which calls both forge_profile_filter.reset_cache() and registry.reset_cache() and broadcasts list_changed — it returned {"reloaded":true,"generation":2,"last_reason":"admin_reload",...} and NO service restart was required. The 44 is fully accounted for: the file holds 47 entries, of which 2 are disabled (ai-compressor, memory) and 1 is the mesh itself (self-excluded), so 47-2-1=44 — the aws-mcp entry IS served. `GET /servers` shows it as enabled with command /usr/bin/mcp-proxy-for-aws and the endpoint + --metadata AWS_REGION=REPLACE_WITH_OPERATIONS_REGION args; `GET /search?q=aws` returns it, which proves it is in the enabled pool because search() skips disabled entries. `GET /mounts` -> {"mounts":[],"count":0} — nothing is mounted, so aws-mcp is not mounted either. `mcp-mesh doctor` reports 1 check failed, but that FAIL is PRE-EXISTING and proven by a differential run: doctor against the live registry and against the pre-change backup produced byte-identical output, and the single FAIL names only cortex (required_env CORTEX_MCP_TOKEN not bound) and librenms (LIBRENMS_TOKEN not declared in required_env) — never aws-mcp. The two WARNs (env-merge-empty, env-divergence) are likewise identical in both runs. `app-admin/mcp-forge` still imports and runs: `python3.13 -c 'import mcp_forge'` -> OK, version 0.24.0; /usr/bin/mcp-forge --help runs cleanly.)
- [x] 5.3 Confirm no profile references the new server, so the fleet's active tool surface is
  unchanged by this change
  (DONE 2026-10-24 — No profile references the new server. `grep -rn 'aws' /etc/mcp-forge/profiles/ /root/.config/mcp-forge/profiles/` returns no matches. The profiles present are /etc/mcp-forge/profiles/{opencode.yaml, prime-agent.yaml} (plus dated .bak copies) and the same pair under /root/.config/mcp-forge/profiles/; each carries name, server_names: [mcp-mesh], env_overrides, server_overrides and an allowed_servers list of ~41 names with no aws entry. This is the mechanism that makes 'registered but unused' real rather than theoretical: mcp-mesh mounts only servers permitted by the Z1 allowed_servers filter (forge_profile_filter.py:145-227; callers app.py:785-787, policy.py:314-316, mcp_frontend.py:399,459, session_revival.py:152-155, cli.py:2931), so a server no profile lists is never mounted even though it sits in the enabled pool — confirmed at runtime by GET /mounts returning an empty list.)

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
- **Follow-up (task 4.5): contribute the worked AWS MCP Server registry example upstream** to the
  mcp-mesh repository (`gitlab-ee.thehavennet.org.uk/ai-ml/mcp-mesh`), so the overlay can ship it
  natively from `contrib/mcp-forge/registry.yaml.example` instead of carrying its own copy in
  `app-admin/mcp-mesh/files/`. Until upstream adopts it the overlay keeps the local copy, which
  is why the example is shipped from the overlay's `files/` directory rather than forked from
  upstream. Tracked here, not done by this change.
