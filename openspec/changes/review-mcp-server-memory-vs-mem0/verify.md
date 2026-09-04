# Verification: review-mcp-server-memory-vs-mem0

> **TIMING**: produced at apply-time, after `git rm dev-util/mcp-server-memory/`
> is committed and the host has unmerged the installed package.

## §0 Pre-conditions

- `git rm -r dev-util/mcp-server-memory/` committed and pushed.
- `sudo emerge --unmerge dev-util/mcp-server-memory` succeeded.
- The `memory:` block removed from `~/.config/mcp-forge/registry.yaml`
  and synced to `/etc/mcp-forge/registry.yaml`.

## Validation Table

| Gate | Command | Pass criterion | Status |
|---|---|---|---|
| Ebuild removed from source | `git ls-files dev-util/mcp-server-memory/` | empty | TBD |
| Package unmerged | `ls /var/db/pkg/mcp-server-memory* 2>&1` | empty | TBD |
| Distfile freed (optional) | `ls /usr/portage-distfiles/mcp-server-memory*` | empty | TBD |
| Registry clean | `grep -A2 'name: memory' ~/.config/mcp-forge/registry.yaml` | empty | TBD |
| Mesh doesn't try to mount | `mcp-mesh mounts` and `mcp-mesh doctor` | no entry, no warnings referencing `memory` | TBD |
| mem0 still works | `curl http://127.0.0.1:7780/mcp/` etc. | unchanged behaviour | TBD |

## §1 Post-conditions

- [ ] Commits landed on master with conventional message.
- [ ] No `md5-cache/` diffs in the committed tree (per AGENTS.md).
- [ ] `mcp-mesh doctor` no longer references `memory`.
