# AWS MCP Server migration

`dev-util/mcp-server-aws` (the self-hosted **AWS API MCP Server**) is end-of-life.
Upstream deprecated it in favour of the managed, AWS-hosted **AWS MCP Server**, which
is reached through a thin local proxy packaged as `dev-util/mcp-proxy-for-aws`.

This document is the contract for moving a host from one to the other.

## Atoms

| Atom | State | What it is |
|---|---|---|
| `dev-util/mcp-proxy-for-aws` | **current** | The thin proxy (`mcp-proxy_for_aws`) that forwards MCP traffic to the managed, AWS-hosted endpoint. Provides `/usr/bin/mcp-proxy-for-aws`. |
| `dev-util/mcp-server-aws` | **masked** | The retired self-hosted server. The ebuild stays on disk; `profiles/package.mask` carries `>=dev-util/mcp-server-aws-1.3.36`. Remove that one line and re-emerge to restore it. |

`dev-util/mcp-meta` with `USE=aws` resolves to the **successor**. The flag name did
not change, but the semantics did: the flag used to select a locally-running server
and now selects a proxy to a remote one. That is a semantic change, not a rename.

## Configuration contract

The retired package was configured through the `env` block of an MCP client config.
The successor takes almost nothing there: remove the whole `"env": { ... }` block and
pass the endpoint and (optionally) metadata as arguments instead.

The table below is the full upstream mapping — every setting the retired server
supported, and what happens to it. Twelve rows, covering eighteen individual
variables. The six "no equivalent" rows cover eleven individual variables that have
no counterpart at all.

| Retired setting | What it did | Successor equivalent |
|---|---|---|
| `AWS_REGION` | Default AWS Region for operations | `--metadata AWS_REGION=<region>` as an argument to the proxy |
| `AWS_API_MCP_PROFILE_NAME` | Selected a named AWS credential profile | `--profile <name>` with the proxy |
| `READ_OPERATIONS_ONLY` | Restricted execution to read-only operations | IAM condition keys on the managed server, or the proxy's `--read-only` flag |
| `REQUIRE_MUTATION_CONSENT` | Required explicit consent before write operations | Not needed — IAM policies control write access |
| `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` / `AWS_SESSION_TOKEN` | Supplied explicit AWS credentials | Configure via `aws configure` / `aws login`; the proxy uses the local credential chain |
| `AWS_API_MCP_WORKING_DIR` | Working directory for file operations | **No equivalent** — the managed server uses sandboxed execution; local file paths are not used |
| `AWS_API_MCP_ALLOW_UNRESTRICTED_LOCAL_FILE_ACCESS` | Controlled local file system access scope | **No equivalent** — no local file system access on the managed server |
| `EXPERIMENTAL_AGENT_SCRIPTS` | Enabled experimental agent scripts | Replaced by built-in skills, reachable via `aws___retrieve_skill` |
| `AWS_API_MCP_AGENT_SCRIPTS_DIR` | Custom scripts directory | **No equivalent** — use Agent Toolkit skills instead |
| `AWS_API_MCP_TRANSPORT` / `AWS_API_MCP_HOST` / `AWS_API_MCP_PORT` | Configured HTTP transport mode | **No equivalent** — the managed server handles transport; the proxy speaks stdio locally |
| `AUTH_TYPE` / `AUTH_ISSUER` / `AUTH_JWKS_URI` | Configured OAuth for HTTP mode | Built into the managed server — configure via its OAuth or SigV4 options |
| `AWS_API_MCP_TELEMETRY` | Controlled telemetry | **No equivalent** — observability is provided via CloudWatch and CloudTrail |

## The two Regions are independent

The successor uses two Regions, and they are not the same thing:

- **The endpoint URL Region** — the Region in
  `https://aws-mcp.us-east-1.api.aws/mcp`. This is where the managed MCP server runs.
- **The operations Region** — `--metadata AWS_REGION=<region>`. This is the default
  Region for the AWS operations the agent performs.

They can differ. **Omitting `--metadata AWS_REGION` defaults all operations to
`us-east-1`**, which is almost never what a fleet wants. Always set it explicitly.

The overlay's shipped examples deliberately carry the invalid placeholder
`AWS_REGION=REPLACE_WITH_OPERATIONS_REGION` so that a verbatim paste fails loudly
instead of silently defaulting operations to `us-east-1`.

## Tool surface

The two servers expose different tools, so any prompt, skill or steering document
that names a tool must be updated.

| Retired tool | Successor tool |
|---|---|
| `call_aws` | *removed* — use `aws___run_script` |
| `suggest_aws_commands` | *removed* |
| `get_execution_plan` (experimental) | *removed* |

Live tools on the successor: `aws___run_script` (sandboxed Python — chains several
API calls in one pass), `aws___search_documentation`, `aws___read_documentation`,
`aws___retrieve_skill`, `aws___list_regions`, `aws___get_regional_availability`,
`aws___get_presigned_url`, `aws___get_tasks`.

API coverage does not change: anything reachable through `call_aws` is reachable
through `aws___run_script`, which resolves to the same underlying AWS API surface.

> **The upstream migration guide is out of date on this point.** It names
> `aws___call_aws` as the rename of `call_aws`. The live managed server does
> **not** expose that tool. Verified on 2026-10-24 by querying the endpoint
> directly — bypassing the proxy entirely — and again through the proxy: both
> return exactly the eight tools listed above. `aws___run_script` is the
> functional replacement, and the server's own instructions tell the agent to
> load tools and then use `run_script`.

### Remove hardcoded `call_aws` references

The successor's own migration guide is explicit about this, and so is this
overlay: **remove hardcoded `call_aws` lines from your Skills, context files,
prompts and steering documents.** Those lines told the agent exactly which single
API call to make; they are now over-specified and they break. Replace a series of
`call_aws` lines with a plain description of the goal and let the agent compose the
script.

The upstream agent rule that replaces them is
["Prefer the AWS MCP Server for AWS interactions"](https://github.com/aws/agent-toolkit-for-aws/blob/main/rules/aws-agent-rules.md).

## The packaged atom is the pin

Client configuration in this overlay names the **native path** and the endpoint:

```json
{
  "mcpServers": {
    "aws-mcp": {
      "command": "/usr/bin/mcp-proxy-for-aws",
      "timeout": 100000,
      "transport": "stdio",
      "args": [
        "https://aws-mcp.us-east-1.api.aws/mcp",
        "--metadata",
        "AWS_REGION=REPLACE_WITH_OPERATIONS_REGION"
      ]
    }
  }
}
```

The proxy is **never resolved through a runtime package resolver**. Upstream's own
guide shows an invocation that resolves the proxy at run time, which has two
drawbacks the overlay deliberately avoids:

1. Every transitive dependency is resolved to its newest version at install time —
   a supply-chain risk if any of them is ever compromised.
2. It contradicts the overlay's Native Path Alignment standard: the instructions
   for every packaged MCP server point at the native `/usr/bin` path, not at a
   runtime resolver.

Because the proxy is packaged as an ebuild, **the installed ebuild version is the
pin** — a stronger guarantee than a version string in a client config, because the
binary on disk is the reviewed artifact. (Consequently no runtime-resolver
invocation appears anywhere in this overlay, and no `@latest` pin either.)

## Delete the old entry, do not add alongside it

The two tools ship from different servers. **Delete the retired client entry
entirely.** Leaving both registered at once causes tool-name conflicts that
confuse the agent.

## Credentials — the accurate position

API *execution* moves AWS-side: the managed server performs the API calls.

**Request signing stays local.** The proxy uses `fastmcp` directly for SigV4
signing, request hooks and error handling, so it still draws on the local AWS
credential chain. **The local credential chain remains in use** — this setup does
not take credentials off the host, and it must not be described as if it did.
What does change is that the proxy forwards requests rather than holding a
long-lived session against the AWS APIs, and every API call is recorded in AWS
CloudTrail for a complete audit trail, with CloudWatch metrics separating agent
activity from human activity.

## Client configuration traps (measured 2026-10-25)

Three things about the successor are unlike the retired local server, and all
three were measured rather than assumed.

**Do not set `AWS_PROFILE` unless that profile exists.** The proxy builds a
boto3 session at *startup* — `server.py:79` → `utils.py:258` →
`sigv4_helper.py:195-197` — and exits `1` when the named profile is absent
(`ProfileNotFound`). The retired server tolerated a missing profile because it
only touched credentials when a tool was called; the successor is eager. The
failure surfaces badly: opencode reports the dead process as a generic
`MCP error -32000: Connection closed`, with nothing about profiles or
credentials. Drop the `environment` block unless it carries a profile that
really exists.

**Give the client a timeout.** The proxy needs about **9.9 s** to answer
`initialize` and about **12.7 s** for the full handshake (initialize →
initialized → tools/list). opencode's flat `mcp.<name>` form defaults to a
**5000 ms** request timeout, so an entry without a timeout is cut off before the
proxy can answer. Set `timeout` explicitly. opencode's schema has **no
`transport` field** at all, and `stdio` is the default transport for a
command-based server in every client here, so it is not written out.

**Expect an explicit error, not a hang, when credentials are missing.** The
proxy signs the `initialize` request itself, so with no AWS identity it
answers with JSON-RPC `-32603` — *"No AWS credentials available. Configure
credentials or use `--skip-auth` to send unsigned requests."* — and opencode
prints that verbatim. That is the honest failure and it is the one to fix: a
local AWS credential chain is required (`aws configure` or `aws login`). Do not
reach for `--skip-auth` to hide it: unsigned requests are rejected by AWS, so
the tools would list and then every call would fail, which is harder to
diagnose than an error at startup.

## Registering the server in the fleet mesh

`app-admin/mcp-mesh` ships a worked example of the entry:
`/etc/mcp-forge/registry.aws-mcp.example.yaml` (installed from this overlay's own
`files/` directory).

The example ships **disabled**. In the mcp-mesh schema `enabled: false` means
*known but disabled* — the entry is retained so a mount failure can be classified
as "known but disabled" rather than "unknown name". It is **not** the same thing
as "available".

The genuinely *available but unused* state is: `enabled: true`, and **no profile
names the server**. mcp-mesh mounts only the servers a client's profile permits
through the Z1 `allowed_servers` filter, so a server that no profile lists is never
mounted even though it sits in the enabled pool. That is the state this host's live
registration uses.

To activate it on a host:

1. Copy the entry from `/etc/mcp-forge/registry.aws-mcp.example.yaml` into
   `/etc/mcp-forge/registry.yaml` under `servers:`.
2. Set the operations Region — replace the invalid
   `AWS_REGION=REPLACE_WITH_OPERATIONS_REGION` placeholder.
3. Flip `enabled` to `true`.
4. Reload the mesh: `POST /admin/reload` (a restart also works).
5. Optionally add the server to a profile's `allowed_servers` to let a client mount
   it. Until then it stays registered, enabled and unmounted.

## Host checklist

- [ ] `emerge --ask=n dev-util/mcp-proxy-for-aws` — the proxy is installed and
      `/usr/bin/mcp-proxy-for-aws` exists.
- [ ] The retired client entry is **deleted** from every MCP client config.
- [ ] The successor entry is added, naming `/usr/bin/mcp-proxy-for-aws` and the
      managed endpoint.
- [ ] The operations Region is set explicitly via `--metadata AWS_REGION=`.
- [ ] Every hardcoded `call_aws` reference is removed from skills, context files,
      prompts and steering documents.
- [ ] A local AWS credential chain is configured (`aws configure` or `aws login`) —
      the proxy signs requests locally, and refuses to start without one.
- [ ] The client entry sets an explicit `timeout` (opencode's default of 5000 ms is
      shorter than the proxy's ~10 s `initialize`).
- [ ] The client entry does **not** set `AWS_PROFILE` unless that profile exists —
      a missing profile is a startup crash, not a runtime warning.
