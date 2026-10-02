## Hypothesis

Both upstreams are abandoned: sheepdog (SourceForge project, `git://` transport) and bbcp (Bitbucket project removed by its author). No replacement remote exists anywhere reachable.

## Evidence

- `scripts/verify-git-uris.sh` flags both: `git://sheepdog.git.sf.net` → FAIL (git:// protocol), `https://bitbucket.org/piotrkarbowski/bbcp.git` → FAIL (connection/404).
- GitHub disabled `git://` in 2022; SourceForge's git service is defunct; the bitbucket repo 404s.
- Neither package has a versioned (non-9999) ebuild pointing at a newer upstream — nothing to bump to.

## Root Cause

Dead upstream: the projects no longer publish source at any reachable remote; the ebuilds are unfetchable by design, not by configuration.

## Blast Radius

- 2 ebuilds: `sys-cluster/sheepdog-9999`, `net-misc/bbcp-9999`.
- Repo policy (AGENTS.md): dead-upstream packages are recorded in `profiles/package.mask` rather than deleted, so `ebuild-updater` stops refreshing them.
- No other packages depend on either.
