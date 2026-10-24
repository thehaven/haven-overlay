# Proposal

## Why

Upstream `awslabs/aws-api-mcp-server` has entered end of development and its own server emits a
deprecation notice on every start — the string is a hardcoded constant in `server.py:76`
(`DEPRECATION_MESSAGE`), prepended to the tool schemas of `aws_call_aws` and
`aws_suggest_aws_commands` (lines 80/95/190/385) and logged at startup (line 435). The overlay
packages that server as `dev-util/mcp-server-aws`, so every host that installs the overlay inherits
an end-of-life tool surface with no upgrade path inside the overlay.

The successor is materially different, not a rename: the AWS API MCP Server is a **managed,
remote, AWS-hosted** server, and the only thing installed locally is a thin proxy
(`mcp-proxy-for-aws`, upstream `aws/mcp-proxy-for-aws`, PyPI latest `1.7.0`). The proxy forwards
to `https://aws-mcp.us-east-1.api.aws/mcp`; the AWS calls execute on the AWS side, not on the
machine that runs the proxy. The tool surface changes accordingly — `call_aws`,
`suggest_aws_commands` and `get_execution_plan` are all removed, and eight new tools appear
including `aws___run_script` (sandboxed Python that chains API calls). **Corrected during
implementation (task 8.1, 2026-10-24):** upstream's migration guide names `aws___call_aws` as the
rename of `call_aws`, but the live managed server does not expose that tool — verified twice,
through the proxy and directly against the endpoint. `aws___run_script` is the live replacement.

## What Changes

- **Add** `dev-util/mcp-proxy-for-aws` — a new ebuild for PyPI `mcp-proxy-for-aws`, the thin proxy
  for the managed AWS MCP Server. It is a **new package, not a bump** of `dev-util/mcp-server-aws`:
  different upstream organisation (`aws/*` not `awslabs/*`), different package name, different
  dependency set, and a different execution model. The overlay's duplicate pre-flight
  (`ls -d */mcp-proxy-for-aws`, `grep -rl 'aws/mcp-proxy-for-aws' --include=*.ebuild`,
  `grep -rl 'mcp-proxy-for-aws' metadata`) returns nothing, so a new atom is correct.
- **Retire** `dev-util/mcp-server-aws` — mask it in `profiles/package.mask` under the overlay's
  existing "Dead upstream" convention rather than deleting the ebuild, and **unmerge it on hosts
  that carry it**, so no end-of-life server remains installed behind the mask. Reversibility is
  preserved at the mask level: removing one line and re-emerging restores it.
- **BREAKING** — Repoint the `aws` USE flag of `dev-util/mcp-meta` from `dev-util/mcp-server-aws`
  to `dev-util/mcp-proxy-for-aws`. `mcp-meta` currently hard-depends on `aws? (
  dev-util/mcp-server-aws )`; after this change it must depend on the new atom or the meta-package
  pulls a masked, unmaintained server back in. The flag name is unchanged — this is a semantic
  change (local server → managed remote server) and it is announced as such, not disguised.
- **Change** the client-setup snippet emitted by `pkg_postinst()` — the old ebuild prints
  `"command": "/usr/bin/awslabs.aws-api-mcp-server"` for Gemini CLI, Claude Desktop and OpenCode.
  The successor is not a local daemon, so the snippet must name the **native path**
  `/usr/bin/mcp-proxy-for-aws` against the managed endpoint, with the region carried in
  `--metadata AWS_REGION=` rather than in an `env` block. The overlay's convention for all forty
  MCP ebuilds is native paths rather than runtime resolvers, and upstream's own migration guide
  warns that an unpinned runtime install resolves every transitive dependency to its newest
  version at install time.
- **Change** the client configuration contract for operators — the `env` block disappears entirely.
  `AWS_REGION` moves to `--metadata AWS_REGION=`; `AWS_API_MCP_PROFILE_NAME` moves to `--profile`;
  `READ_OPERATIONS_ONLY` becomes an IAM condition key or the proxy's `--read-only`;
  `REQUIRE_MUTATION_CONSENT` is not needed because IAM policies now control write access; explicit
  `AWS_ACCESS_KEY_ID`/`AWS_SECRET_ACCESS_KEY`/`AWS_SESSION_TOKEN` are replaced by the local
  credential chain (`aws configure`/`aws login`); and `AWS_API_MCP_WORKING_DIR`,
  `AWS_API_MCP_ALLOW_UNRESTRICTED_LOCAL_FILE_ACCESS`, `AWS_API_MCP_AGENT_SCRIPTS_DIR`,
  `AWS_API_MCP_TRANSPORT`/`_HOST`/`_PORT`, `AUTH_TYPE`/`AUTH_ISSUER`/`AUTH_JWKS_URI` and
  `AWS_API_MCP_TELEMETRY` have no equivalent.
- **Add** the fleet mesh as a fourth integration surface. `app-admin/mcp-mesh` installs
  `/etc/mcp-forge/registry.yaml.example` and performs just-in-time tool mounting, so a server
  listed under `servers:` and referenced by no profile is *available but unused*. The overlay ships
  a worked example of the managed AWS MCP Server from its own `files/` directory rather than
  forking the upstream template, and the change registers the server in the fleet registry without
  adding it to any profile.
- **Add** resolve-time protection for the fastmcp consumers. No overlay ebuild upper-bounds
  `fastmcp` below 4 today — fourteen are unbounded and the rest carry minimums only — so the single
  `>=dev-python/fastmcp-4.0.0` line in `profiles/package.mask` is the only thing holding the fleet
  below fastmcp 4.x. `app-admin/mcp-mesh` declares `dev-python/mcp` unbounded and is protected only
  by the analogous `>=dev-python/mcp-2.0.0` mask, which bites at install time rather than at
  resolve time. The installed stable gains an explicit bound, and a guard asserts the bound on the
  current version of each consumer — the same class of load-bearing declarative state as the
  recorded PEP517 backend-drift and `acct-user_add_deps` incidents.
- **Add** a per-package ebuild test at `scripts/tests/test_mcp_proxy_for_aws_ebuild.py`, matching the
  precedent set by `test_grafonnet_ebuild.py`, `test_headroom_ai_ebuild.py` and
  `test_litellm_ebuild.py`.
- **Add** a migration note to the overlay documentation covering the tool renames and the removal
  of hardcoded `call_aws` references from skills, context files, prompts and steering documents —
  the upstream guide is explicit that those over-specified references break.

## Capabilities

### New Capabilities

- `aws-mcp-packaging`: How the overlay packages AWS MCP access — the successor proxy is packaged
  and current, the deprecated self-hosted server is masked and unmeged, the `mcp-meta` `aws` USE
  flag resolves to the successor, the client-setup instructions and documented configuration
  contract match the managed-server model, the fleet mesh registry can carry the managed server
  available-but-unused, and fastmcp consumers declare a resolve-time bound rather than relying on
  an ecosystem mask.

### Modified Capabilities

None. The overlay's only existing capability is `bun-slotting`, which is unrelated.

## Impact

- **New atom** `dev-util/mcp-proxy-for-aws` — ebuild, metadata manifest entries, and a
  `metadata/md5-cache/` entry on merge. The md5-cache is reported, not enforced — the webhost
  regenerates it in bulk.
- **Retired atom** `dev-util/mcp-server-aws` — masked, not deleted, and unmeged on hosts that carry
  it so no end-of-life server remains installed behind the mask.
- **Modified atom** `dev-util/mcp-meta` — its `aws` USE flag repointed. A bump is required because
  `mcp-meta` carries the flag→package mapping, so the change cannot be invisible.
- **Modified atom** `app-admin/mcp-mesh` — the installed stable gains an explicit
  `<dev-python/mcp-2` bound; retired versions are left alone so the fix propagates to future bumps
  without rewriting history.
- **Client configurations outside the overlay** — every MCP client that references
  `awslabs.aws-api-mcp-server` must be updated: the server entry is replaced (never kept
  alongside the old one, which causes tool-name conflicts), the tool names change, and any skill,
  prompt, context file or steering document that hardcodes `call_aws` must be rewritten to a
  goal description. The upstream agent rule
  `https://github.com/aws/agent-toolkit-for-aws/blob/main/rules/aws-agent-rules.md` is the
  recommended replacement.
- **Supply-chain posture** — the packaged atom *is* the pin. Client configuration names the native
  path and the endpoint and never resolves the proxy through a runtime package resolver, so no
  unpinned install can pull fresher transitive dependencies at runtime.
- **Governance** — with the managed server, every API call is recorded in CloudTrail and surfaced in
  CloudWatch metrics that separate agent activity from human activity, and the proxy forwards
  rather than performing the AWS calls itself. Signing is the exception: SigV4 signing stays local
  and the proxy still uses the local credential chain, so this change does not claim zero
  credential exposure.
- **Host state** — the fleet mesh registry gains an AWS MCP Server entry that no profile
  references, and the retired package is unmeged. Neither changes any host's active tool surface.
- **Not in scope** — the Agent Toolkit for AWS is the successor to the AWS Labs MCP servers, plugins
  and skills. It is one level further up and is not what this change implements.
