## 1. Identify the real upstream

- [x] 1.1 Research which codex project this ebuild is meant to package (candidate: `github.com/openai/codex` — confirm purpose, licence, git tags) [unit: web research against official repo] — **Done 2026-09-18**: `openai/codex` is a Rust CLI ("Lightweight coding agent that runs in your terminal"); it does not match this Python/hatchling ebuild. No `ai-ml/codex` project exists (404). No verifiable upstream.
- [x] 1.2 Confirm anonymous fetch works as the portage user: `sudo -u portage git ls-remote <candidate-url> HEAD` (regression gate: current state fails, proving the bug) [smoke] — **Done**: the `ssh://` URI is flagged by `verify-git-uris.sh` (see 4.1).

## 2. Fix the ebuild

- [ ] 2.1 (N/A — fallback path taken, see 3.1) Set `EGIT_REPO_URI` to the verified public https URL and `HOMEPAGE` to the web URL; drop the `ssh://` forms [unit: `grep -n 'EGIT_REPO_URI\|HOMEPAGE' app-misc/codex/codex-9999.ebuild`]
- [ ] 2.2 (N/A — fallback path taken, see 3.1) Run `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` → codex URI green (RED → GREEN) [integration]
- [ ] 2.3 (N/A — fallback path taken, see 3.1) Clean install smoke test: `sudo ebuild app-misc/codex/codex-9999.ebuild clean install`, then fetch/unpack as the portage user [smoke]

## 3. Fallback: mask

- [x] 3.1 If no verifiable public upstream exists: add `app-misc/codex` to `profiles/package.mask` with a comment citing the missing upstream [unit: `grep codex profiles/package.mask`] — **Done 2026-09-18**: masked in `profiles/package.mask`.
- [x] 3.2 Confirm no `metadata/discover-hooks` entry chases codex [integration] — **Done**: no discover/bump hook exists for codex.

## 4. Verify

- [x] 4.1 Full gate run: `sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh` — exit 0 or masked-and-skipped [smoke] — **Done 2026-09-18**: codex URI reports a masked SKIP; the gate script now honours `profiles/package.mask` (previously it failed masked packages while documenting mask as a resolution). Remaining FAIL lines (docker-updater, librarian, sheepdog, bbcp) are pre-existing and tracked by `resolve-private-egit-repos` / `mask-dead-upstream-ebuilds`.
