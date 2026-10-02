## 1. Mask dead-upstream packages

- [x] 1.1 Add `net-fs/sheepdog` and `net-misc/bbcp` to `profiles/package.mask` with a comment citing the dead upstream and date [unit: `grep -n 'sheepdog\|bbcp' profiles/package.mask`]
- [x] 1.2 Regenerate the metadata cache: `sudo -n egencache --repo=haven-overlay --update` [integration]
- [x] 1.3 Confirm `ebuild-updater status` no longer proposes bumps for either package [smoke]

## 2. Align the gate

- [x] 2.1 Extend `scripts/verify-git-uris.sh` to skip ebuilds masked in `profiles/package.mask` (already implemented) [integration: script exits 0 with masked entries present]

## 3. Verify

- [x] 3.1 Full gate run: `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` — skips masked packages [smoke]
