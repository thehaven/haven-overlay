# Spec Delta

## Purpose

Defines how the haven-overlay packages AWS MCP access: which upstream server is packaged as current,
how the deprecated self-hosted server is retired, how the `mcp-meta` meta-package resolves its
`aws` flag, and what the documented client-setup contract must look like for the managed-server
model.

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

### Requirement: Client setup instructions target the managed endpoint

The post-install message SHALL instruct operators to configure the client with a `uvx` invocation
of the pinned proxy against the managed endpoint, and SHALL NOT print a local-daemon command for
the retired server.

- **Expected:** the emitted JSON names the proxy, the endpoint URL and `--metadata AWS_REGION=`.
- **Verification:** `grep -c 'awslabs.aws-api-mcp-server'` over the ebuild returns 0.
- **Rollback:** restore the previous post-install text.

#### Scenario: Operator reads the post-install message
- **WHEN** the package is installed on a supported Python interpreter
- **THEN** the message shows a copy-pasteable client entry using the proxy and the managed endpoint, not the local server binary

#### Scenario: The proxy is named in the emitted configuration
- **WHEN** the post-install text is searched for the proxy name
- **THEN** the count is non-zero, and the pinned version is part of the emitted argument

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

### Requirement: The proxy version is pinned in client configuration

Documented client configuration SHALL pin an exact proxy version rather than resolving `latest`, and
the overlay's own emitted snippet SHALL pin an exact version too.

- **Expected:** no documented or emitted client entry resolves the proxy from `latest`.
- **Verification:** `grep -rn 'mcp-proxy-for-aws@latest'` over the overlay returns no match.
- **Rollback:** restore the unpinned text.

#### Scenario: Operator copies the configuration
- **WHEN** an operator copies the emitted snippet into a client configuration
- **THEN** the transitive dependency set resolved at install time is the one that was reviewed, not whatever is newest on the day

#### Scenario: The packaged version and the emitted pin move together
- **WHEN** the packaged proxy version is bumped
- **THEN** the emitted pin names the same version

### Requirement: The tool surface change is documented

The overlay's documentation SHALL record the renamed and removed tools, the new tools, and the
requirement that hardcoded `call_aws` references be removed from skills, context files, prompts and
steering documents.

- **Expected:** the renames, the removals and the new tools are enumerated.
- **Verification:** the documentation names all three tool dispositions and the removal instruction.
- **Rollback:** revert the documentation change.

#### Scenario: An agent still references the old tool name
- **WHEN** an agent configuration or skill file still hardcodes a `call_aws` invocation
- **THEN** the documentation tells the operator to replace it with a goal description and points at the upstream AWS agent rules

#### Scenario: The new tools are enumerated
- **WHEN** the tool-surface section is read
- **THEN** `aws___run_script`, `aws___search_documentation`, `aws___read_documentation`, `aws___retrieve_skill`, `aws___list_regions`, `aws___get_regional_availability`, `aws___get_presigned_url` and `aws___get_tasks` are each named
