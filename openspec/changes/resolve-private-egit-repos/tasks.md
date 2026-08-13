## 1. Decide per repository (owner action — blocks everything else)

- [ ] 1.1 Owner: make `ai-ml/cortex` public on gitlab-ee (Project → Settings → General → Visibility, or API `PUT /projects/:id {visibility: public}`) [smoke: `sudo -u portage git ls-remote https://gitlab-ee.thehavennet.org.uk/ai-ml/cortex.git HEAD`]
- [ ] 1.2 Owner: make `ai-ml/librarian` public [smoke: same probe for librarian.git]
- [ ] 1.3 Owner: make `gentoo/docker-updater` public [smoke: same probe for docker-updater.git]

## 2. Migrate ebuilds for repos that became public

- [ ] 2.1 Switch `EGIT_REPO_URI` to `https://gitlab-ee.thehavennet.org.uk/{ai-ml,gentoo}/<name>.git` for cortex 0.7.2/0.8.3/9999, librarian-9999, docker-updater 0.1.0/0.2.0/0.3.0; delete the `file://`/ssh URI forms (regression gate: `scripts/verify-git-uris.sh` flags the old forms) [smoke: script turns green]
- [ ] 2.2 Run `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` → exit 0 for all migrated URIs [integration]
- [ ] 2.3 Real fetch smoke test as the portage user: `sudo -u portage emerge --fetchonly =app-misc/cortex-9999` (or `ebuild ... unpack`) [smoke]

## 3. Mask any repo that stays private

- [ ] 3.1 Add the still-private packages to `profiles/package.mask` with a comment citing the private repo (per repo dead-upstream policy) [unit: `grep <pkg> profiles/package.mask`]
- [ ] 3.2 Extend `scripts/verify-git-uris.sh` to skip ebuilds masked in `profiles/package.mask` (so the gate reports only actionable failures) [integration: script exits 0 with masked packages present]

## 4. Verify

- [ ] 4.1 Full gate: `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` exits 0 [smoke]
- [ ] 4.2 Confirm `ebuild-updater status` no longer flags the resolved packages [integration]
