## 1. Identify the real upstream

- [ ] 1.1 Research which codex project this ebuild is meant to package (candidate: `github.com/openai/codex` — confirm purpose, licence, git tags) [unit: web research against official repo]
- [ ] 1.2 Confirm anonymous fetch works as the portage user: `sudo -u portage git ls-remote <candidate-url> HEAD` (regression gate: current state fails, proving the bug) [smoke]

## 2. Fix the ebuild

- [ ] 2.1 Set `EGIT_REPO_URI` to the verified public https URL and `HOMEPAGE` to the web URL; drop the `ssh://` forms [unit: `grep -n 'EGIT_REPO_URI\|HOMEPAGE' app-misc/codex/codex-9999.ebuild`]
- [ ] 2.2 Run `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` → codex URI green (RED → GREEN) [integration]
- [ ] 2.3 Clean install smoke test: `sudo ebuild app-misc/codex/codex-9999.ebuild clean install`, then fetch/unpack as the portage user [smoke]

## 3. Fallback: mask

- [ ] 3.1 If no verifiable public upstream exists: add `app-misc/codex` to `profiles/package.mask` with a comment citing the missing upstream [unit: `grep codex profiles/package.mask`]
- [ ] 3.2 Confirm no `metadata/discover-hooks` entry chases codex [integration]

## 4. Verify

- [ ] 4.1 Full gate run: `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` — exit 0 or masked-and-skipped [smoke]
