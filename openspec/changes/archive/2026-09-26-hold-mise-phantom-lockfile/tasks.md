## 1. Pin `dev-util/mise` on the hold list

- [x] 1.1 Add `dev-util/mise` to `[repos.haven-overlay.pipeline].hold` in
      `/var/db/repos/haven-overlay/ebuild-updater.toml`, with a comment
      matching the existing six-entry phantom-crate block (lines 48-63):
      cite `base64 = "^0.23" locked to 0.23.1` as the probe evidence
      [unit: `grep -n "dev-util/mise" ebuild-updater.toml`]
      *(applied 2026-09-26: line 69; TOML re-parse OK)*

## 2. Align gates

- [ ] 2.1 Regenerate metadata cache: `sudo -n egencache --repo=haven-overlay
      --update` (mirrors the policy used in `mask-dead-upstream-ebuilds`)
      [integration: exit 0]
- [ ] 2.2 Confirm `ebuild-updater status` no longer proposes a bump for
      `dev-util/mise` (hold takes effect at next run)
      [smoke: `ebuild-updater status --repo haven-overlay 2>&1 | grep -E "^dev-util/mise" || echo "OK: mise not flagged"`]

## 3. Verify

- [ ] 3.1 `openspec validate hold-mise-phantom-lockfile --strict` passes
      [integration: exit 0]
- [ ] 3.2 Next nightly run: no `dev-util/mise-2026.9.14 failed (compile
      phase)` line in `/var/log/ebuild-updater-nightly.log`
      [smoke: `awk '/mise/ && /failed/' /var/log/ebuild-updater-nightly.log | wc -l` → 0]
- [ ] 3.3 Full gate: `openspec validate --all --strict` exit 0
      [integration]