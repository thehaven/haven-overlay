# Tasks

Each task states how to verify completion. Groups land their own tests and documentation; group 6
is integration-only.

## 1. Package the successor

- [ ] 1.1 Add `dev-util/mcp-proxy-for-aws/mcp-proxy-for-aws-1.7.0.ebuild` — `EAPI=8`,
  `PYPI_PN="mcp-proxy-for-aws"`, `DISTUTILS_USE_PEP517=hatchling`,
  `PYTHON_COMPAT=( python3_{12..14} )`, `inherit distutils-r1 pypi`, `HOMEPAGE` pointing at
  `https://github.com/aws/mcp-proxy-for-aws`, `LICENSE="Apache-2.0"`, `SLOT="0"`,
  `KEYWORDS="~amd64"`; verify `ebuild dev-util/mcp-proxy-for-aws` parses and
  `ebuild ... manifest` produces the Manifest entry
- [ ] 1.2 Declare `RDEPEND` faithful to the upstream wheel: `boto3>=1.41.0`,
  `botocore[crt]>=1.41.0`, `fastmcp>=3.2,<3.5`, `httpx>=0.27.1,<1.0`; verify
  `ebuild ... dependencies` shows the fastmcp upper bound `<3.5` and that `fastmcp-3.4.7` is the
  only overlay version satisfying it
- [ ] 1.3 Implement `src_prepare()` with the hatchling backend fix-up the current AWS ebuild uses
  (`sed -i 's/build-backend = "uv_build"/build-backend = "hatchling.build"/' pyproject.toml`), and
  verify it against an unpacked sdist rather than at install time
- [ ] 1.4 Implement `python_test()` with an import check that resolves the successor's real module
  layout; verify the check passes against the unpacked sdist and that it **fails** when pointed at
  a directory with no importable module (a positive control, so a passing check means something)
- [ ] 1.5 Implement `pkg_postinst()` emitting the successor client snippet for Gemini CLI, Claude
  Desktop and OpenCode — `uvx` + `mcp-proxy-for-aws@1.7.0` + the managed endpoint URL +
  `--metadata AWS_REGION=` — and verify the retired string `awslabs.aws-api-mcp-server` appears
  **zero** times in the ebuild
- [ ] 1.6 Add `scripts/tests/test_mcp_proxy_for_aws_ebuild.py` following
  `test_litellm_ebuild.py` / `test_grafonnet_ebuild.py` / `test_headroom_ai_ebuild.py`; verify
  `pytest scripts/tests/` passes with the new file included

## 2. Resolve the dependency set — the gate

- [ ] 2.1 Run `emerge --pretend --ask=no dev-util/mcp-proxy-for-aws` and confirm the resolved set
  selects `fastmcp-3.4.7`; verify the output contains **no** `fastmcp-4.x` and no unsatisfiable
  constraint
- [ ] 2.2 Run `emerge --pretend --ask=no dev-util/mcp-meta` with `USE=aws` and diff the resolved
  dependency set against the current one; verify the **only** difference is the fastmcp version
  and the AWS MCP atom, and that all 36 fastmcp dependents remain satisfiable
- [ ] 2.3 Verify the endpoint is reachable from a representative host before cutover — probe
  `https://aws-mcp.us-east-1.api.aws/mcp` — and record the result in the change's notes

## 3. Retire the old package and repoint the meta-package

- [ ] 3.1 Add `dev-util/mcp-server-aws` to `profiles/package.mask` under the existing
  "Dead upstream" block with a dated reason; verify `emerge --pretend dev-util/mcp-server-aws`
  now refuses and that the ebuild file is **still present** on disk
- [ ] 3.2 Bump `dev-util/mcp-meta` with the `aws` USE flag repointed from
  `dev-util/mcp-server-aws` to `dev-util/mcp-proxy-for-aws`; verify the new version's RDEPEND
  maps `aws? ( dev-util/mcp-proxy-for-aws )` and that the previous version's ebuild is left intact
- [ ] 3.3 Regenerate the overlay Manifest and the `metadata/md5-cache` entry for the new atom;
  verify `egirepository`/`ebuild ... manifest` reports no missing entries

## 4. Document the migration

- [ ] 4.1 Add the configuration-contract mapping table to the overlay documentation — one row per
  old setting, giving the successor equivalent, including an explicit **"no equivalent"** row for
  each of the nine settings that do not carry over (`AWS_API_MCP_WORKING_DIR`,
  `AWS_API_MCP_ALLOW_UNRESTRICTED_LOCAL_FILE_ACCESS`, `AWS_API_MCP_AGENT_SCRIPTS_DIR`,
  `AWS_API_MCP_TRANSPORT`/`_HOST`/`_PORT`, `AUTH_TYPE`/`AUTH_ISSUER`/`AUTH_JWKS_URI`,
  `AWS_API_MCP_TELEMETRY`); verify every old setting in the retired ebuild appears in the table
- [ ] 4.2 Document the tool-surface change — `call_aws` → `aws___call_aws`, `suggest_aws_commands`
  and `get_execution_plan` removed, the eight new tools listed — and the instruction to **remove**
  hardcoded `call_aws` references from skills, context files, prompts and steering documents,
  pointing at the upstream AWS agent rule; verify the upstream rule URL is present and resolves
- [ ] 4.3 Document the two independent Regions — the endpoint URL Region (where the managed server
  runs) versus `--metadata AWS_REGION` (the operations Region), that omitting the latter defaults
  operations to `us-east-1`, and that the old entry must be **deleted** rather than left alongside
  the new one; verify all three statements appear
- [ ] 4.4 Document the pinned proxy version and that `@latest` must not be used, with the
  supply-chain rationale; verify `rtk grep -rn 'mcp-proxy-for-aws@latest' .` returns nothing

## 5. Overlay consistency

- [ ] 5.1 Verify the overlay carries no second ebuild for either upstream:
  `ls -d */mcp-proxy-for-aws`, `rtk grep -rl 'aws/mcp-proxy-for-aws' --include='*.ebuild' .` and
  `rtk grep -rl 'mcp-proxy-for-aws' metadata` — the first may match only the new atom, the other
  two must return nothing else
- [ ] 5.2 Run the full overlay test suite `pytest scripts/tests/` and verify every test passes,
  including the three pre-existing ebuild tests
- [ ] 5.3 Run `ebuild dev-util/mcp-proxy-for-aws clean` and a `--pretend` emerge; verify no
  Portage warnings and that the manifest is consistent

## 6. Integration verification

- [ ] 6.1 On a host with the successor installed, confirm the MCP server exposes `aws___call_aws`
  and that `call_aws` and `suggest_aws_commands` are **absent** from the tool list
- [ ] 6.2 Execute one read-only AWS call through the successor and confirm the operation lands in
  the intended operations Region (not the endpoint Region, and not the `us-east-1` default)
- [ ] 6.3 Confirm the fastmcp downgrade on that host left every other MCP package working — check
  each installed `dev-util/mcp-server-*` package still starts and serves its tools

## Workflow follow-up

- Commit only after explicit user approval (overlay AGENTS.md). Conventional-commit style:
  `dev-util/mcp-proxy-for-aws: add package for the managed AWS MCP Server` and
  `dev-util/mcp-meta: repoint aws flag to the managed AWS MCP Server`.
- Archive the change after the project's review requirements are satisfied.
- Client-configuration changes on each host (including this host's
  `~/.config/opencode/opencode.json`) are separate repositories and need their own approval; they
  are not performed by this change.
