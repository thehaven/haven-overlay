# Spec Delta

## Purpose

Defines how the haven-overlay packages AWS MCP access: which upstream server is packaged as current,
how the deprecated self-hosted server is retired, how the `mcp-meta` meta-package resolves its
`aws` flag, what the documented client-setup contract must look like for the managed-server
model, how the fleet mesh registry carries the managed server, and how fastmcp-consuming
packages are kept inside the overlay's supported fastmcp range.

## ADDED Requirements

### Requirement: The managed AWS MCP Server proxy is packaged as current

The overlay SHALL package the thin proxy for the managed AWS MCP Server as a new atom, and that
atom SHALL be the only current AWS MCP package the overlay offers.

- **Expected:** `dev-util/mcp-proxy-for-aws` exists and builds the `mcp-proxy-for-aws` PyPI dist.
- **Verification:** `ls -d dev-util/mcp-proxy-for-aws` resolves; `emerge -pv` resolves a version.
- **Rollback:** `git revert` the ebuild commit and regenerate the manifest.

#### Scenario: Operator installs AWS MCP access from the overlay
- **WHEN** an operator emerges `dev-util/mcp-meta` with the `aws` USE flag enabled
- **THEN** the resolver installs the managed-server proxy and NOT the deprecated self-hosted server

#### Scenario: The ebuild declares its upstream
- **WHEN** the ebuild is inspected
- **THEN** `PYPI_PN` is `mcp-proxy-for-aws` and `HOMEPAGE` names `https://github.com/aws/mcp-proxy-for-aws`

#### Scenario: The build backend is verified, not inherited
- **WHEN** the ebuild declares `DISTUTILS_USE_PEP517`
- **THEN** the value matches the `build-backend` declared by the packaged sdist, and no fix-up `sed` is copied from a sibling ebuild without that sdist proving it necessary

### Requirement: The deprecated self-hosted AWS API MCP server is masked

The overlay SHALL record `dev-util/mcp-server-aws` in `profiles/package.mask` under its existing
dead-upstream convention, and SHALL NOT delete the ebuild.

- **Expected:** the atom is masked, the ebuild file remains, and the mask carries a dead-upstream reason.
- **Verification:** `grep -n 'mcp-server-aws' profiles/package.mask` matches; the ebuild still exists.
- **Rollback:** remove the mask line and regenerate the manifest.

#### Scenario: A stale dependency asks for the retired atom
- **WHEN** a package depends on `dev-util/mcp-server-aws`
- **THEN** Portage reports the dependency as masked rather than installing an end-of-life server

#### Scenario: Masking does not delete
- **WHEN** the mask is applied
- **THEN** `dev-util/mcp-server-aws/mcp-server-aws-1.3.36.ebuild` is still on disk and a host may unmask and install it

#### Scenario: A host that carries the retired package is cleaned up
- **WHEN** the mask is applied and a host still has the retired atom installed
- **THEN** the host unmerges it, so no end-of-life server remains installed behind the mask

### Requirement: The mcp-meta aws flag resolves to the successor

The `aws` USE flag of `dev-util/mcp-meta` SHALL resolve to `dev-util/mcp-proxy-for-aws`, and the
meta-package SHALL be bumped so the change is visible to the resolver.

- **Expected:** a new `mcp-meta` version maps `aws` to the new atom.
- **Verification:** `grep -n 'aws? (' dev-util/mcp-meta/*.ebuild` names the new atom; the masked atom appears in no version.
- **Rollback:** revert the bump and restore the flag mapping.

#### Scenario: Meta-package is upgraded
- **WHEN** an operator upgrades `dev-util/mcp-meta`
- **THEN** the `aws` flag brings in the successor proxy and no unsatisfiable dependency is raised

#### Scenario: The flag name is unchanged
- **WHEN** the new `mcp-meta` version is read
- **THEN** the flag is still named `aws`, so existing `USE="... aws"` expressions keep working

#### Scenario: The semantic change is announced
- **WHEN** the new `mcp-meta` version is read
- **THEN** it records that `USE=aws` now selects a managed remote server rather than a local one

### Requirement: Client setup instructions target the managed endpoint

The post-install message SHALL point operators at the **native** packaged proxy and the managed
endpoint, and SHALL NOT print the retired daemon.

- **Expected:** the JSON names `/usr/bin/mcp-proxy-for-aws`, the endpoint URL and `--metadata AWS_REGION=`.
- **Verification:** `grep -c 'awslabs.aws-api-mcp-server'` returns 0 and the native path appears.
- **Rollback:** restore the previous post-install text.

#### Scenario: Operator reads the post-install message
- **WHEN** the package is installed on a supported Python interpreter
- **THEN** the message shows a copy-pasteable client entry using the native proxy and the managed endpoint, not the local server binary

#### Scenario: The native path is used, not a runtime resolver
- **WHEN** the emitted configuration is inspected
- **THEN** the command is the packaged `/usr/bin/mcp-proxy-for-aws` binary and does not invoke a runtime package resolver

#### Scenario: All three supported clients are covered
- **WHEN** the post-install message is generated
- **THEN** it carries an entry for Gemini CLI, Claude Desktop and OpenCode

### Requirement: The documented configuration contract uses the proxy's own flags

The overlay's documentation of AWS MCP configuration SHALL describe only settings that exist on the
managed-server proxy, and SHALL state the migration path for every setting that does not carry over.

- **Expected:** every documented setting exists on the proxy; non-carrying settings are listed with their disposition.
- **Verification:** the documentation contains no instruction to set a removed variable.
- **Rollback:** revert the documentation change.

#### Scenario: Operator carries an old configuration forward
- **WHEN** an operator copies a pre-migration client configuration containing the old `env` block
- **THEN** the documentation states which key becomes which flag, and states that the remaining old keys have no equivalent

#### Scenario: The removed variables are enumerated
- **WHEN** the migration table is read
- **THEN** `AWS_API_MCP_WORKING_DIR`, `AWS_API_MCP_ALLOW_UNRESTRICTED_LOCAL_FILE_ACCESS`, `AWS_API_MCP_AGENT_SCRIPTS_DIR`, `AWS_API_MCP_TRANSPORT`, `AWS_API_MCP_HOST`, `AWS_API_MCP_PORT`, `AUTH_TYPE`, `AUTH_ISSUER`, `AUTH_JWKS_URI` and `AWS_API_MCP_TELEMETRY` each appear with a disposition of "no equivalent"

#### Scenario: The credential variables are redirected
- **WHEN** the migration table is read
- **THEN** `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` and `AWS_SESSION_TOKEN` are documented as replaced by the local credential chain, and `AWS_REGION` is documented as moving to `--metadata AWS_REGION=`

#### Scenario: The credential statement is accurate
- **WHEN** the governance section is read
- **THEN** it states that API execution moves to the managed server while request signing still uses the local credential chain

### Requirement: The packaged proxy version is the pin

The proxy version SHALL be pinned by the packaged atom itself. Client configuration emitted by the
overlay SHALL NOT resolve the proxy from a moving tag or through a runtime package resolver.

- **Expected:** the packaged version is the only version a client can invoke.
- **Verification:** `grep -rn 'mcp-proxy-for-aws@latest'` over the overlay returns no match.
- **Rollback:** restore the previous text.

#### Scenario: Operator copies the configuration
- **WHEN** an operator copies the emitted snippet into a client configuration
- **THEN** the dependency set resolved is the one the overlay packaged and reviewed, not whatever is newest on the day

#### Scenario: The packaged version and the emitted entry move together
- **WHEN** the packaged proxy version is bumped
- **THEN** the emitted entry names the same packaged version

### Requirement: The tool surface change is documented

The overlay's documentation SHALL record the retired tools, the live tool list, and the requirement
that hardcoded `call_aws` references be removed from skills, context files, prompts and steering
documents.

- **Expected:** the removals and the live tool list are enumerated.
- **Verification:** the documentation names all three tool dispositions and the removal instruction.
- **Rollback:** revert the documentation change.

#### Scenario: An agent still references the old tool name
- **WHEN** an agent configuration or skill file still hardcodes a `call_aws` invocation
- **THEN** the documentation tells the operator to replace it with a goal description and points at the upstream AWS agent rules

#### Scenario: The new tools are enumerated
- **WHEN** the tool-surface section is read
- **THEN** `aws___run_script`, `aws___search_documentation`, `aws___read_documentation`, `aws___retrieve_skill`, `aws___list_regions`, `aws___get_regional_availability`, `aws___get_presigned_url` and `aws___get_tasks` are each named

#### Scenario: The live server does not expose the tool named by the upstream guide
- **WHEN** the managed server is queried for its tool list
- **THEN** the documentation states that `aws___call_aws` is NOT served, that `aws___run_script` is the functional replacement for `call_aws`, and that the retired names `call_aws`, `suggest_aws_commands` and `get_execution_plan` are absent

### Requirement: The fleet mesh registry carries the managed server

The overlay SHALL ship a worked registry example with `app-admin/mcp-mesh`, and SHALL register
the server **without** adding it to any profile.

- **Expected:** the example names the native proxy and endpoint; the live registry gains an unreferenced server entry.
- **Verification:** `grep -rn 'aws-mcp' /etc/mcp-forge/` matches a server entry; no profile names it.
- **Rollback:** remove the registry entry and the example.

#### Scenario: The server is available but unused
- **WHEN** the fleet registry is read
- **THEN** the managed AWS MCP Server is listed under servers and is referenced by no profile

#### Scenario: An operator has a template to copy
- **WHEN** an operator needs to add the server to a client
- **THEN** the overlay ships a copy-pasteable registry example

#### Scenario: The upstream template is not forked
- **WHEN** the change is applied
- **THEN** the worked example is carried by the overlay, and an upstream contribution to the mesh registry template is raised as a separate follow-up

### Requirement: Fastmcp-consuming packages declare a resolve-time bound

Every package that consumes `dev-python/fastmcp` SHALL declare an upper bound below `4`, so that
resolution cannot silently select an unsupported fastmcp even if the ecosystem mask is regenerated.

- **Expected:** each fastmcp consumer's current version declares `<dev-python/fastmcp-4`.
- **Verification:** the overlay's fastmcp guard test passes; a deliberately unpinned consumer is detected.
- **Rollback:** revert the guard and the pins.

#### Scenario: The ecosystem mask is regenerated away
- **WHEN** the `>=dev-python/fastmcp-4.0.0` mask line is removed or narrowed
- **THEN** resolution still cannot select fastmcp 4.x, because the bound is declared in the consumers

#### Scenario: The currently installed mesh package is pinned
- **WHEN** `app-admin/mcp-mesh` is inspected
- **THEN** its installed stable version declares a bound below `dev-python/mcp` 2.x, rather than relying on the mask alone

#### Scenario: The guard does not demand the pin in retired versions
- **WHEN** the guard scans a package with several historical versions
- **THEN** it asserts the bound on the current version only, so the fix propagates to future bumps without rewriting history
