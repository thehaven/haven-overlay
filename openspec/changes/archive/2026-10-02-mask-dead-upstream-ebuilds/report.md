## Symptom

Two ebuilds reference dead upstreams and can never fetch: `sys-cluster/sheepdog-9999` (`EGIT_REPO_URI="git://sheepdog.git.sf.net"`) and `net-misc/bbcp-9999` (`https://bitbucket.org/piotrkarbowski/bbcp.git`). Both fail in `src_unpack`.

## Environment

- Gentoo, haven-overlay at `/var/db/repos/haven-overlay`
- Discovered during the 2026-08-13 audit (`scripts/verify-git-uris.sh`)

## Reproduction Steps

1. `sudo -u portage git ls-remote https://bitbucket.org/piotrkarbowski/bbcp.git HEAD` → connection failure / 404 (project removed)
2. `git ls-remote git://sheepdog.git.sf.net` → protocol dead (`git://` transport was disabled industry-wide in 2022; sf.net project abandoned)
3. Run `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` → both URIs flagged (git:// = FAIL, bitbucket = FAIL)

## Expected vs Actual

**Expected:** fetchable upstream sources for both packages.
**Actual:** both upstreams are gone (abandoned projects, removed remotes) and `git://` as a transport is dead — the ebuilds cannot build from any reachable source.
