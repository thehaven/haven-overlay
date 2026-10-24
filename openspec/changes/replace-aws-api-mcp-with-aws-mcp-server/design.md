# Design

## Context

Three facts drive this design.

1. **The successor is a different upstream, not a bump.** `awslabs/aws-api-mcp-server` is end-of-life.
   Its replacement is the managed AWS MCP Server, reached through a thin local proxy
   (`mcp-proxy-for-aws`, upstream `aws/mcp-proxy-for-aws`). The overlay's duplicate-package rule
   ("never add a second ebuild for the same upstream — extend or bump instead") therefore does not
   apply: the duplicate pre-flight returns nothing for the successor's identity, and a bump is
   impossible because the upstream organisation, package name, dependency set and execution model
   all differ. A new atom is correct.

2. **The fastmcp range the successor declares is already the overlay's range.** The successor
   declares `fastmcp>=3.2,<3.5`. The overlay's `profiles/package.mask` already masks
   `>=dev-python/fastmcp-4.0.0` and `>=dev-python/mcp-2.0.0` (the "Ecosystem hold"), so
   `fastmcp-3.4.7` is the only installable fastmcp and is already installed fleet-wide. There is
   **no downgrade** and no state change for the 36 fastmcp dependents. The successor's `<3.5` cap
   is the same constraint family the overlay already enforces globally, and upstream's own
   `pyproject.toml` says the cap "matches mcp's own".

   The corollary is a fragility: **no overlay ebuild upper-bounds fastmcp below 4** — 14 declare it
   unbounded and the rest declare a minimum only. The single mask line is the only thing holding
   the fleet below fastmcp 4.x. If the ebuild-updater regenerates that mask away, every
   minimum-only consumer silently resolves fastmcp 4.x → mcp 2.x → `mcp.server.fastmcp` removed →
   fleet-wide import break. That is the same class as the recorded PEP517 backend-drift and
   `acct-user_add_deps` incidents: a single line of declarative state, load-bearing and unguarded.
   The successor is the first ebuild to carry the bound in its own dependency declaration; this
   change makes that the pattern.

3. **The `mcp-meta` flag→package mapping lives inside the meta ebuild.** Repointing `USE=aws` at
   the successor is a semantic change, not just a dependency swap: `USE=aws` currently means "a
   local AWS MCP server" and afterwards means "a managed remote AWS MCP server" with different
   credential handling, different Region semantics and different tool names. The mapping can only
   be changed by editing the meta ebuild, so the change is necessarily visible as a version bump.

## Goals

- The overlay offers exactly one current AWS MCP package, and it is the managed-server proxy.
- `dev-util/mcp-meta` with `USE=aws` resolves to the successor.
- Client-setup instructions match the successor's execution model and the overlay's own
  "Native Path Alignment" convention.
- The fleet mesh registry can carry the managed server, available but not mounted.
- Fastmcp-consuming packages are protected by a declared bound, not only by a mask.
- The retired package stays **recoverable** — masked, not deleted.

## Non-Goals

- Migrating any host's MCP client configuration. Those are separate repositories with separate
  approvals.
- The **Agent Toolkit for AWS**, which is one level further up than the managed AWS MCP Server.
- Aliasing upstream's tool names. The overlay does not publish a `call_aws` compatibility alias.
- Publishing the successor to the Gentoo tree.
- Providing the managed endpoint itself; it is an AWS-hosted service.

## Decisions

### D1 — New atom for the successor; the retired atom is masked, not deleted

A new atom `dev-util/mcp-proxy-for-aws` is added and `dev-util/mcp-server-aws` is recorded in
`profiles/package.mask` under the file's existing "Dead upstream" convention.

*Rejected:* keeping both packages unmasked — upstream is explicit that running both at once causes
tool-name conflicts that confuse the agent. *Rejected:* deleting the retired ebuild — the overlay
masks dead upstream rather than deleting it, and the mask keeps the fallback one line away.

### D2 — Declare the fastmcp bound faithfully; treat the mask as the remaining fragility

The successor's `fastmcp>=3.2,<3.5` is declared exactly as upstream declares it.

*Rejected:* leaving `fastmcp` unbounded — that would silently ship an untested fastmcp 4.x, which
the mask already forbids and which breaks `mcp.server.fastmcp` consumers fleet-wide.
*Rejected:* adding a new fastmcp 3.x ebuild — `fastmcp-3.4.7` already exists and already satisfies
the range.

Because the mask is the only thing holding fastmcp below 4 fleet-wide, this change also adds a
**resolve-time** guard (D10) so the successor's bound is not the only ebuild-level bound.

### D3 — One `aws` flag, repointed in place, with the semantic change made loud

`dev-util/mcp-meta` keeps a single `aws` USE flag, repointed from `dev-util/mcp-server-aws` to
`dev-util/mcp-proxy-for-aws` in a new version derived from the newest in-tree version (`5.6.9`),
which is left intact.

*Rejected:* a new `aws-managed` flag — it splits fleet expectations, forces every consumer to
change their `USE` expression, and contradicts the overlay's recorded lesson "always fix the
newest in-tree version, not just the broken one | fixes propagate to all future bumps
automatically".

The semantic change is made loud rather than silent: the new meta version records that `USE=aws`
now selects a managed remote server, and the successor's `pkg_postinst()` prints a migration
notice naming the tool renames.

### D4 — The native path, not `uvx`

The post-install snippet emits `"command": "/usr/bin/mcp-proxy-for-aws"` with the managed endpoint
URL and `--metadata AWS_REGION=` as arguments.

Upstream's own migration guide shows a `uvx mcp-proxy-for-aws@1.6.3 <endpoint>` invocation, but
the overlay's established convention for all 40 MCP-related ebuilds is the opposite: *"Native Path
Alignment: instructions point to the native `/usr/bin` paths instead of `npx` or `uvx`, improving
build stability and reducing runtime overhead"*. The overlay packages the proxy, so the native path
exists and the convention wins. Emitting `uvx` would also reintroduce exactly the risk upstream
itself warns about — an unpinned runtime install resolves every transitive dependency to its
newest version at install time.

Upstream's requirement that the proxy version be pinned is satisfied differently and more
strongly: the **packaged ebuild version is the pin**. There is no second copy of the version
number for the client to drift from.

### D5 — No build-backend fix-up is copied from the sibling ebuild

Upstream `mcp-proxy-for-aws` 1.7.0 declares `build-backend = "hatchling.build"` in its own
`pyproject.toml`, so `DISTUTILS_USE_PEP517=hatchling` needs no `sed`. The retired ebuild's
`src_prepare()` seds `uv_build` → `hatchling.build` because *that* package declared `uv_build`.

*Rejected:* copying the sibling's `src_prepare()` — this is the recorded anti-pattern "always
verify each version's tarball independently, never assume siblings share a build backend", which
cost 47 ebuilds across 11 packages in a single undetected drift. The backend is verified against
the successor's own sdist.

### D6 — `python_test()` imports the real module and asserts the console script

The upstream `mcp_proxy_for_aws` package deliberately has **no `__init__.py`** — `__version__` reads
the installed distribution's metadata instead of carrying a literal. `import mcp_proxy_for_aws`
therefore succeeds as a namespace package even if the actual code is broken, so the auto-generated
`${PN//-/_}` import check is a false pass. The check imports `mcp_proxy_for_aws.server` — the
console-script target — and asserts that `/usr/bin/mcp-proxy-for-aws` exists. A negative control
(an import against a directory with no importable module) must fail.

### D7 — The configuration contract is published in full, including what has no equivalent

Every old setting is mapped. The nine settings that do not carry over are listed explicitly with a
"no equivalent" disposition rather than being silently dropped.

The governance statement is deliberately **not** "zero credential exposure". API execution moves
to the AWS-hosted managed server, but the proxy still signs requests locally with SigV4 — upstream
declares `fastmcp` directly "for SigV4 signing" — so the local credential chain is still used. The
honest statement is that the *execution* moves AWS-side while *signing* stays local.

### D8 — Tool-surface changes are documented, and hosts must remove hardcoded `call_aws`

`call_aws` → `aws___call_aws`; `suggest_aws_commands` and `get_execution_plan` are removed; eight
new tools are enumerated. Upstream is explicit that hardcoded `call_aws` references in skills,
context files, prompts and steering documents break, so the documentation instructs removal and
points at the upstream AWS agent rule.

*Rejected:* an overlay-published `call_aws` compatibility alias — it would publish a name upstream
does not know, and the overlay would then have to maintain it.

### D9 — The fleet mesh registry is a fourth integration surface

`app-admin/mcp-mesh` installs `/etc/mcp-forge/registry.yaml.example`, and mcp-mesh does
just-in-time tool mounting. A server listed under `servers:` but referenced by no profile is
therefore *available but unused* — exactly the required state.

The worked example is carried **by the overlay**, from its own `files/` directory, rather than
forking the upstream mesh template: the upstream file lives in the `mcp-mesh` repository, and
forking it in the overlay would diverge on every bump. An upstream contribution carrying the same
example is raised as a follow-up task.

The server is registered in the fleet registry **after** the proxy is installed, so the registry
never names a binary that is not present.

### D10 — Fastmcp consumers get a resolve-time bound, asserted on the current version only

Two things follow from the survey:

- `app-admin/mcp-mesh` declares an **unbounded** `dev-python/mcp` and is **not** in
  `scripts/tests/test_mcp_pin.py`'s fixed `FASTMCP_PACKAGES` set. It is protected today only by the
  `>=dev-python/mcp-2.0.0` mask, which bites at install time, not at resolve time. Its installed
  stable version (`0.22.1`) therefore gains an explicit `<dev-python/mcp-2` bound.
- The existing `test_mcp_pin.py` guard is **text-based and per-ebuild across every version**.
  Adding `app-admin/mcp-mesh` to that set as-is would demand the bound in all eight of its ebuilds
  (0.17.0–0.22.1 plus 9999), which contradicts the overlay's own lesson about fixing the newest
  version rather than rewriting history. The guard is therefore extended with a **current-version**
  assertion rather than a wholesale set membership.

The successor's `fastmcp>=3.2,<3.5` is the first ebuild-level upper bound on fastmcp in the tree
and is the pattern the new guard enforces.

### D11 — The retired package is masked and unmerged

The mask is an open-ended `>=` range, matching the overlay's recorded convention for blocks. A host
that still carries `dev-util/mcp-server-aws` unmerges it, so no end-of-life server remains
installed behind the mask. Reversibility is preserved at the **mask** level — removing one line
and emerging the old atom restores it — not at the installed level.

## Risks and trade-offs

| Risk | Mitigation |
|---|---|
| The managed endpoint is a new failure mode — the retired package worked against the local AWS API | The retired atom stays masked-but-installable; the mask is one line to remove |
| The `>=dev-python/fastmcp-4.0.0` mask line is removed or regenerated away | The resolve-time guard (D10) means consumers carry their own bound; the successor already does |
| `app-admin/mcp-mesh` resolves mcp 2.x on a fresh install if the mask moves | Its installed stable version declares `<dev-python/mcp-2` explicitly |
| Tool renames silently break prompts and skills that hardcode `call_aws` | Documented removal instruction plus the upstream agent rule; a broken hardcoded reference is a security control, not just a bug |
| Running both server entries at once causes tool conflicts | The old entry must be **deleted**, stated in the migration documentation |
| The managed endpoint is a preview service | The proxy version is pinned by the package; the endpoint URL is explicit in the emitted configuration |
| `python_test()` passes on a namespace package | The check imports `mcp_proxy_for_aws.server` and asserts the console script; a negative control must fail |
| `ebuild <file> manifest` **writes** the Manifest and `egencache` **mutates** `metadata/md5-cache/` | Both may only run in a scratch copy. The overlay's own convention is that md5-cache is **reported, not enforced** — the webhost regenerates it in bulk — so it is not a gate |
| `emerge --pretend` against an atom with no ebuild passes **vacuously** | The resolution gate is sequenced strictly after the ebuild lands, and "no ebuilds to satisfy" is classified **not checked**, never clean |
| Unmerging the retired package removes the only installed fallback | Reversibility is retained at the mask level (D11) |
| A registry entry names a proxy that is not installed yet | The registry entry is added only after the proxy is emerged (D9) |

## Migration Plan

1. **Package** — write the successor ebuild, the meta-package bump, the mask, the overlay-local
   registry example and the tests.
2. **Resolve (the gate)** — `emerge --pretend` against the new atom, with a negative control.
   Only after this step does "no ebuilds to satisfy" become a meaningful answer.
3. **Retire** — mask the old atom; unmerge it on hosts that carry it.
4. **Apply** — emerge the successor, repoint `mcp-meta`, emerge the meta-package.
5. **Register** — add the managed server to the fleet registry under `servers:`, referenced by no
   profile.
6. **Validate** — `mcp-mesh doctor`, the mesh health and readiness endpoints, the registry parse,
   the tool-surface check, and one read-only AWS call landing in the intended operations Region.

**Rollback.** Remove the mask line and revert the meta-package bump; the previous client entry and
the previous registry state are restored. Where a fastmcp downgrade had to be undone, `emerge
fastmcp-4.1.3` restores it. None of these require a rebuild.

## Open Questions

Neither of these changes the approach, the specification or the task list.

1. Does `aws___run_script`'s sandboxed Python meet the organisation's data-handling policy? This is
   a policy question for the owner, not a packaging question.
2. Which Region should be the fleet's default operations Region? The emitted configuration leaves it
   an explicit placeholder by design, so that omitting `--metadata AWS_REGION=` can never silently
   default operations to `us-east-1`.
