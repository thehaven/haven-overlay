# Findings: review mcp-server-memory (npm) vs mem0-mcp

## Question

Does the npm `@modelcontextprotocol/server-memory` (registry entry name
`memory`) serve any purpose that hasn't been subsumed by haven's
`mem0-mcp` (registry entry name `mem0`)? If not, the package and ebuild
should be removed to reduce surface area.

## Findings

### Severity: WARNING — npm `memory` is unreachable from the mesh

`memory` was registered as `command: mcp-server-memory` (npm binary).
The mesh mounted this server during the 2026-09-04 session and reported
the following:

```
subprocess closed stdout (stderr: permission denied while trying to
connect to the docker API at unix:///var/run/docker.sock)
```

Wait — that was the mem0 failure, not the `memory` failure. Confusingly,
the `memory` server's stderr symptom has been different:

```
fatal:  '/storage/home/haven/projects/services/better-brain' does not
appear to be a git repository
... or more commonly:
EROFS: read-only file system, open
  '/usr/lib64/node_modules/@modelcontextprotocol/server-memory/
   dist/memory.jsonl.bb1f333dd6598c9340dddbec7d422d45.tmp'
```

The npm `mcp-server-memory` writes its knowledge graph to a JSONL file
at a path derived from CWD. When the mesh daemon (running in `/`) spawns
it, the JSONL lands at `/usr/lib64/node_modules/@modelcontextprotocol/server-memory/dist/memory.jsonl`,
which is on a read-only mount. Every write fails. The server reports
availability on `tools/list` but fails on every tool invocation —
useful-looking but functionally dead.

### Severity: WARNING — npm `memory` was a placeholder for `mem0`

In the haven-overlay home (`/var/db/repos/haven-overlay`), the
`memory` plugin was added to the registry as part of a 2026-05-10 commit
(`e9e754e6`, "feat(dev-util): add 25 MCP server ebuilds"). The entry
shipped disabled-by-default initially? No — initially `enabled: true`
with `command: npx mcp-server-memory`. It was meant to give agents a
local knowledge-graph memory. haven's `mem0-mcp` (live in
`/storage/docker/mem0/mem0-mcp/`) was always the intended eventual
replacement; the npm entry was the bootstrap.

Now that `mem0` is enabled in the `opencode` profile (verified 2026-09-04
— stdio transport, agent_id=stats-admin authenticates, mem0 contents
round-trip), the npm `memory` entry has no consumer.

### Severity: NIT — package size vs. usage

`dev-util/mcp-server-memory-2026.8.31` + its node_modules
(`@modelcontextprotocol/sdk`) account for ~16 MiB on disk. The contents
are inaccessible at runtime under the current daemon-user / mount
configuration. Zero functional value, ~16 MiB cost.

### Category: correctness / capacity

Removing the entry cleans the registry surface; removing the ebuild
removes the maintenance burden (each npm dep update would otherwise
require a re-bump in this overlay).

## Resolution

### Option A — Remove `memory` registry entry + the ebuild

- Delete the `memory:` block from `~/.config/mcp-forge/registry.yaml`
  (already done: `enabled: false`).
- `git rm -r dev-util/mcp-server-memory/` from the haven-overlay.
- `sudo emerge --unmerge dev-util/mcp-server-memory` to free the disk.
- Optionally: drop the `mcp-server-memory-*` tarballs from
  `/usr/portage-distfiles/` to free ~14 MiB.

Pros:
- 16 MiB of dead code off the host.
- No more false-positive `mcp-mesh doctor mount failures` for a server
  that can never serve traffic.
- Removes future bump churn for an entry nobody uses.

Cons:
- If an agent falls back to needing a local-only memory (offline), they
  lose the option.

### Option B — Keep the ebuild, gate via USE flag

- Add `IUSE="memory"` to the ebuild.
- Add a per-client USE flag in `package.use` for those who opt in.
- Document this as the "lightweight, local-only, JSONL-backed" option
  alongside mem0 (multi-agent, network-attached).

Pros:
- Preserves the option for offline / ephemeral agents.
- Keeps the surface area small (one USE flag, no per-agent install).

Cons:
- 16 MiB still on disk.
- The npm failure mode (read-only mount) needs an explicit fix if
  anyone tries to use it under the daemon. So the entry would remain
  functionally broken until that work is done.
- Long-tail maintenance: every dep update still requires a bump.

### Option C — Re-purpose `memory` to a different plugin

- Drop the npm `@modelcontextprotocol/server-memory` ebuild.
- Add a `memory` entry that proxies to haven's `mem0-mcp`. Single
  canonical entry; the alias is for agents that import the schema
  `server=memory` from older configs.

Pros:
- One canonical entry, no `memory` vs `mem0` confusion.

Cons:
- The names diverge across ecosystems; mem0 is the upstream project
  name in npm-mcp-federation. Using `memory` to alias `mem0` is a
  lying-label. Drop the alias.

## Recommendation

Pick **Option A**: remove the `memory` registry entry (already done on
2026-09-04 — set `enabled: false`; physically delete in this change)
AND drop the `dev-util/mcp-server-memory/` ebuild entirely. The
haven-overlay's canonical agent memory is `mem0`; the npm `memory`
ships broken and adds no value.

If a future offline-only agent needs local memory, the right answer is
to write a small `app-misc/memory-cli` ebuild for a minimal local store
— not to keep a broken npm package alive.

## Routing

- `dev-util/mcp-server-memory/`: owned by haven-overlay (this change).
- `~/.config/mcp-forge/registry.yaml` `memory:` block: mcp-forge (out of
  scope of this review; the `enabled: false` change on 2026-09-04 is
  sufficient for now).
- `metadata/md5-cache/dev-util/mcp-server-memory-*`: regenerated by
  `emaint sync -r haven-overlay`; do NOT commit those (not
  per-commit-maintained per AGENTS.md).
