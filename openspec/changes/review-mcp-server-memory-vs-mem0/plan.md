# Plan: review-mcp-server-memory-vs-mem0

## Step 1 — `git rm` the ebuild

**Goal**: remove the ebuild from the overlay source.

**Files**: `dev-util/mcp-server-memory/` (entire dir, recursive).

**Steps**:
1. `cd /var/db/repos/haven-overlay`
2. `sudo -n git rm -r dev-util/mcp-server-memory/`
3. Verify the directory is gone, but `dev-util/mcp-meta` and friends
   remain (no transitive dependency).

**Verify command**: `git status` shows only the deletion.
**Commit message**: `dev-util/mcp-server-memory: drop unused npm package superseded by mem0-mcp`

## Step 2 — Unmerge from host

**Goal**: free ~16 MiB.

**Steps**:
1. `sudo -n emerge --unmerge dev-util/mcp-server-memory`. Portage will
   refuse if other packages depend on it; checked that nothing does
   (this is a stand-alone package).
2. `sudo -n rm -f /usr/portage-distfiles/mcp-server-memory-*.gpkg.tar`
   to free distfile cache. (Optional.)
3. Verify: `ls /usr/lib64/node_modules/@modelcontextprotocol/ 2>&1`
   no longer lists `server-memory`.

**Verify command**: `ls /var/db/pkg | grep mcp-server-memory` →
empty after unmerge.
**Commit message**: (no commit — unmerge is host-side, not source.)

## Step 3 — Drop the `memory:` entry from the registry

**Goal**: the mesh no longer tries to mount the dead server.

**Files**: `~/.config/mcp-forge/registry.yaml` (or `/etc/mcp-forge/registry.yaml`).

**Steps**:
1. `cd /storage/home/haven/projects/personal/mcp-forge`
2. Edit `registry.yaml`: remove the `- name: memory` block.
3. Sync the registry to global if running daemon as a different user.
4. `mcp-forge doctor` confirms `registry-source-mismatch` reduces
   (still flagged for the unrelated items, but `memory` is no longer
   the noise).

**Verify command**: `mcp-mesh mounts` shows no `memory` backend.
**Commit message**: `docs(mcp-forge): drop unused memory npm registry entry (superseded by mem0)`
