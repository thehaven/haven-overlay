# Design

## Context

See `proposal.md` — *Why* for the motivation and *What Changes* for the scope. This document covers
the technical approach only.

Three constraints shape the approach, all established by reading the current overlay:

**1. The successor is a different upstream, so the overlay's duplicate-package rule does not apply.**
The overlay's AGENTS.md forbids adding a second ebuild for *the same upstream*. The current package
is `dev-util/mcp-server-aws` (`awslabs-aws-api-mcp-server`); the successor is
`mcp-proxy-for-aws` (`aws/mcp-proxy-for-aws`). The overlay pre-flight returns nothing for all three
checks, so a new atom is correct and a version bump is not possible.

**2. The successor's dependencies land on a fastmcp version that the overlay already ships — but
only at the cost of a downgrade.** `mcp-proxy-for-aws` declares `fastmcp>=3.2,<3.5`. The overlay
ships `dev-python/fastmcp` at 3.4.7, 4.0.10, 4.0.11, 4.1.0, 4.1.1 and 4.1.3. 3.4.7 satisfies the
range; 4.1.3 does not.

Across the whole overlay, 36 ebuilds depend on `dev-python/fastmcp`, with these constraint strings:

| Constraint string | Count | Portage meaning |
|---|---|---|
| `dev-python/fastmcp-3.0.0` | 15 | `>=3.0.0` — a **minimum**, not an exact pin |
| `dev-python/fastmcp` | 14 | unconstrained |
| `dev-python/fastmcp-0.3.0` | 5 | `>=0.3.0` |
| `dev-python/fastmcp-3.4.2` | 1 | `>=3.4.2` |
| `dev-python/fastmcp-0.4.1` | 1 | `>=0.4.1` |

**No overlay package requires `fastmcp >= 4`, and none upper-bounds it.** The successor's
`fastmcp>=3.2,<3.5` would therefore be the only upper bound in the overlay, and it forces
Portage to resolve fastmcp to **3.4.7** — a **downgrade** from the current 4.1.3 for any host
that already has it installed. The downgrade is dependency-safe for all 36 packages, but it is a
state change on a shared dependency and must be planned rather than discovered.

The other successor dependencies resolve from the Gentoo tree without overlay work: `boto3` and
`botocore` at 1.43.86 (satisfies `>=1.41.0`), `httpx` at 0.28.1 (satisfies `>=0.27.1,<1.0`).

**3. `dev-util/mcp-meta` is the mechanism by which hosts get the AWS MCP server.** Its
`aws? ( dev-util/mcp-server-aws )` RDEPEND mapping lives *inside* the meta-package ebuild, so
repointing the flag is a change to the meta-package, which requires a version bump.

## Goals / Non-Goals

**Goals:**

- The overlay offers exactly one current AWS MCP package, built from the upstream the successor
  guide names.
- A host that emerges `dev-util/mcp-meta` with `USE=aws` gets the successor, not the retired one.
- The client-configuration instructions the overlay emits are correct for the successor's
  execution model — a `uvx` proxy invocation against the managed endpoint, not a local binary.
- The overlay's own test suite is extended so the new atom's metadata is checked the same way as
  every other package's.
- The retired package remains **recoverable**: masked, not deleted, with the reason recorded.

**Non-Goals:**

- Migrating any client configuration. The overlay emits instructions; hosts apply them. The
  OpenCode configuration on this host, Gemini CLI, and Claude Desktop are each a separate
  repository and a separate approval.
- Migrating to the **Agent Toolkit for AWS**. Upstream states that is the successor to the MCP
  servers, one level further on. It is out of scope here and should be re-evaluated once the
  managed AWS MCP Server is proven in production.
- Changing the client-facing tool *names* — `aws___call_aws` and friends are upstream's naming.
  The overlay's job is to document them, not to alias them.
- Publishing the successor to the upstream Gentoo tree. The overlay is a layman repo; it never
  takes over a package the tree already ships.
- Providing the managed endpoint itself. It is an AWS-hosted service; the overlay ships the client.

## Decisions

### D1 — Ship the successor as a new atom, and retire the old one by masking

`dev-util/mcp-proxy-for-aws` is added; `dev-util/mcp-server-aws` is added to
`profiles/package.mask` under the existing "Dead upstream" block.

*Alternative considered — bump the existing ebuild to a newer `awslabs-aws-api-mcp-server`
release.* Rejected: upstream has declared the package end-of-development, and the migration guide
describes the successor as a different execution model (remote managed server vs local execution),
not a newer local server. A bump would also not satisfy the overlay's duplicate pre-flight in
spirit, because the upstream repository is moving.

*Alternative considered — delete the old ebuild.* Rejected: the overlay's convention
(`profiles/package.mask`) records dead upstream rather than deleting, and a mask keeps the package
installable on hosts that have not migrated yet, while making `emerge` refuse it on new installs.

*Alternative considered — keep both unmasked.* Rejected: the migration guide is explicit that
running the old and new server entries together causes tool-name conflicts that confuse the
agent. Masking makes "old" the path of least resistance rather than the default.

### D2 — Declare `fastmcp>=3.2,<3.5` faithfully, and accept the downgrade

The new ebuild declares `dev-python/fastmcp>=3.2,<3.5`, exactly as the upstream wheel declares.
Portage then resolves to the overlay's existing `fastmcp-3.4.7`.

*Alternative considered — declare `dev-python/fastmcp>=3.2` with no upper bound.* Rejected: it
keeps fastmcp at 4.1.3 and avoids a downgrade, but it silently installs a version outside the
range upstream declares and upstream tested against. Portage does not enforce the wheel's own
metadata, so an unbounded dependency is a way to ship an untested combination without noticing.

*Alternative considered — add a second `dev-python/fastmcp` ebuild at 3.4.x.* Rejected: the
overlay already ships 3.4.7, so there is nothing to add. The downgrade is a *resolution* outcome,
not a packaging gap.

*Consequence, and it is the reason this decision has a migration step:* every host that currently
has `fastmcp-4.1.3` installed will have it replaced by 3.4.7 when the successor is installed. All
36 dependent packages remain satisfiable because none requires `>=4`. The downgrade is planned
explicitly in the migration plan and verified with `emerge --pretend` before it is committed.

### D3 — Repoint `dev-util/mcp-meta`'s `aws` flag in place, with a version bump

The `aws` USE flag keeps its name and now resolves to `dev-util/mcp-proxy-for-aws`. Because the
flag-to-package mapping is embedded in the meta-package's RDEPEND, the meta-package must be bumped
for the change to take effect — an unsuffixed edit to an installed version is not honoured by the
resolver.

*Alternative considered — add a new `aws-managed` flag and deprecate `aws`.* Rejected: it breaks
every consumer's `USE="... aws"` and forces a two-step migration for no benefit. The flag name
describes the capability, not the implementation.

*Alternative considered — leave `mcp-meta` alone and let hosts emerge the new atom directly.*
Rejected: the meta-package exists precisely so a host gets a consistent MCP set in one emerge. A
meta-package that still pulls the retired package would make the overlay's own recommendation
wrong.

### D4 — Emit a `uvx` proxy invocation, with the region expressed twice and distinctly

The new `pkg_postinst()` prints, for each of the three supported clients:

```
"aws-mcp": {
  "command": "uvx",
  "timeout": 100000,
  "transport": "stdio",
  "args": ["mcp-proxy-for-aws@<pinned>", "https://aws-mcp.us-east-1.api.aws/mcp",
           "--metadata", "AWS_REGION=<region>"]
}
```

Upstream defines **two independent regions**: the Region in the endpoint URL (where the managed MCP
server runs) and `--metadata AWS_REGION` (the default Region for the operations the agent issues).
They may differ. Omitting `--metadata` defaults operations to `us-east-1`.

*Decision — make both explicit in the emitted snippet, with the endpoint pinned to a fixed
Region and the operations Region left as an explicit placeholder.* Rationale: silently inheriting
`us-east-1` because a flag was omitted is exactly the failure mode the old package's
`env.AWS_REGION` made easy to get wrong, and it is the kind of mistake that is invisible until a
resource turns up in the wrong Region.

### D5 — Pin the proxy version in every emitted configuration

The snippet names a specific `mcp-proxy-for-aws` version, never `@latest`.

*Rationale:* upstream's own guide states that an unpinned install resolves all transitive
dependencies to their newest versions at install time, which is a supply-chain risk. This is the
same lesson the LiteLLM deployment in this fleet learned the hard way — an unpinned tag was the
mechanism for a credential-stealer image to run in production.

*Consequence:* the overlay must re-emit the snippet when the pinned version is bumped, so the
pinned version and the packaged version are kept in step. This is stated as a requirement in the
spec delta rather than left to convention.

### D6 — Document the configuration contract as a mapping, including the settings that do not carry over

The overlay's documentation for the successor is a table with one row per old setting, giving the
successor's equivalent. Nine of the old settings have **no** equivalent in the managed model
(`AWS_API_MCP_WORKING_DIR`, `AWS_API_MCP_ALLOW_UNRESTRICTED_LOCAL_FILE_ACCESS`,
`AWS_API_MCP_AGENT_SCRIPTS_DIR`, `AWS_API_MCP_TRANSPORT`/`_HOST`/`_PORT`,
`AUTH_TYPE`/`AUTH_ISSUER`/`AUTH_JWKS_URI`, `AWS_API_MCP_TELEMETRY`).

*Decision — publish the mapping with an explicit "no equivalent" row for each, rather than
documenting only what carries over.* Rationale: a host operator migrating from the old package
needs to know that a setting they rely on has stopped existing, and silence reads as "unchanged".

*Decision — the credential settings are documented as "use the local credential chain"
(`aws configure` / `aws login`), and the explicit `AWS_ACCESS_KEY_ID` /
`AWS_SECRET_ACCESS_KEY` / `AWS_SESSION_TOKEN` form is documented as removed.* Rationale: upstream
states the managed server executes and the proxy only forwards, and describes the posture as zero
credential exposure. The proxy still depends on `boto3`/`botocore` and therefore still touches the
local credential chain for its own operations, so the honest statement is that the *API execution*
moves AWS-side — not that the proxy holds no credentials at all.

### D7 — Ship the tool-surface change as documentation, and tell hosts to remove hardcoded references

The overlay documents the renames (`call_aws` → `aws___call_aws`; `suggest_aws_commands` and
`get_execution_plan` removed) and the eight new tools, and states explicitly that hardcoded
`call_aws` references in skills, context files, prompts and steering documents must be removed
rather than renamed — upstream calls them over-specified and says they will break.

*Alternative considered — ship a compatibility alias.* Rejected: upstream's tool names are the
contract the managed server exposes; an alias in the overlay would be a name the upstream server
does not know, and would reappear as a break at the next upstream change.

### D8 — Extend the overlay's ebuild test suite rather than relying on the review

`scripts/tests/test_mcp_proxy_for_aws_ebuild.py` is added, following the precedent of
`test_grafonnet_ebuild.py`, `test_headroom_ai_ebuild.py` and `test_litellm_ebuild.py`.

*Rationale:* the overlay's own tests validate each package's ebuild against upstream metadata.
A new atom without a test would be the only one in the overlay without one, and the failure mode
it would catch — a dependency or homepage drifting from the upstream dist — is invisible to
`ebuild` itself.

## Risks / Trade-offs

**[The managed endpoint becomes a new external dependency and a new failure mode]** → The overlay
ships the client only; the endpoint is AWS-hosted. A host that cannot reach
`aws-mcp.<region>.api.aws` loses AWS tooling entirely, where before it worked with only outbound
API access. Mitigation: the migration plan keeps the old package **masked but installable** so a
host can fall back by unmasking, and the docs state the endpoint URL explicitly so reachability
can be tested before cutover.

**[The fastmcp downgrade touches 36 packages]** → Installing the successor replaces
`fastmcp-4.1.3` with `fastmcp-3.4.7` on any host that has the newer one. Mitigation: no dependent
package requires `>=4` (verified across every overlay ebuild), so the resolution is satisfiable;
the migration plan runs `emerge --pretend` and diffs the dependency set **before** the change is
committed, and the downgrade is listed as an explicit expected line rather than discovered at
install time.

**[Tool renames break prompts and skills that hardcode `call_aws`]** → Upstream states these
references are over-specified and will break. Mitigation: the overlay documents the rename and the
requirement to remove hardcoded references, pointing at the upstream agent rule
(`aws/agent-toolkit-for-aws` → `rules/aws-agent-rules.md`) that replaces them with a goal
description. The overlay cannot fix third-party prompts; it can only make the requirement
discoverable.

**[Running both server entries causes tool-name conflicts]** → Mitigation: the overlay emits only
the new entry, and the migration plan states the old entry must be **deleted**, not left alongside.

**[The upstream service is in preview]** → The managed AWS MCP Server is listed as "in preview" in
upstream's own get-started table. Mitigation: the package is pinned to a specific proxy version
and the endpoint URL is written into the docs, so a preview retirement is a configuration change
rather than an unexplained outage.

**[The ebuild's `python_test()` import check may not match the successor's module layout]** → The
current ebuild's generated `python_test()` tries `${PN//-/_}` → `mcp_server_${suffix}` → `${suffix}`
and dies if none import. `mcp-proxy-for-aws` may expose a different module name. Mitigation: the
ebuild test asserts the import resolves, and the ebuild's `python_test()` is verified against the
unpacked sdist before the ebuild is committed rather than at install time.

**[A pinned proxy version in client configs will age]** → D5 pins deliberately; the cost is that
the overlay must re-emit when the pin moves. Mitigation: the pin is stated as a requirement so it
is revisited at each bump, and the packaged ebuild version and the emitted pin are stated to move
together.

## Migration Plan

Full detail is in `tasks.md`. The shape:

1. **Package** — add `dev-util/mcp-proxy-for-aws` with the upstream-faithful dependency bounds;
   add the ebuild test; run the overlay test suite.
2. **Resolve** — run `emerge --pretend` for `dev-util/mcp-proxy-for-aws` and for
   `dev-util/mcp-meta` with `USE=aws`, and confirm the fastmcp resolution lands on 3.4.7 with
   no other dependent package unsatisfied. **This is the gate on the whole change.**
3. **Retire** — add the old atom to `profiles/package.mask`; bump `dev-util/mcp-meta` so the
   `aws` flag points at the new atom.
4. **Apply** — on each host: emerge the new atom and the bumped meta-package, then update the
   client configuration (delete the old entry, add the new one), then remove hardcoded `call_aws`
   references from skills, prompts and context files.
5. **Verify** — the new server exposes `aws___call_aws`; the old `call_aws` name is absent; a
   read-only AWS call succeeds against the intended operations Region.

**Rollback.** The old package is masked, not deleted, so rollback is `emerge` with the mask
removed plus restoring the previous client entry. The fastmcp downgrade is reversible by emerging
`fastmcp-4.1.3` explicitly. Neither rollback requires a rebuild or a source change.

## Open Questions

- **Does `aws___run_script`'s sandboxed Python execution meet the organisation's data-handling
  policy?** It is a new capability the local package never had — arbitrary Python, sandboxed,
  executed against the managed server. This is a policy question, not a technical one, and it does
  not change the specs, the approach, or the task breakdown: the package is shipped either way and
  the policy decision governs whether the host enables the tool.
- **Which Region should be the default operations Region for this fleet?** The emitted snippet
  leaves it as an explicit placeholder by design (D4). The overlay can emit any value; the right
  one is the fleet's choice, and the placeholder makes that choice visible rather than implicit.
