## Hypothesis

`dev-util/mise` 2026.9.14 joins the existing "phantom-crate" failure class — its `Cargo.lock` references a crate version (or range) that no longer exists on `static.crates.io`, so the offline `cargo build` cannot resolve it. The six existing holds in `ebuild-updater.toml` (`ast-serialize`, `jsonschema-rs`, `tirith`, `syntax-checker`, `tree-sitter-language-pack`, `agnix`) document exactly this failure mode with verbatim probe evidence. mise has hit the same trap on `base64 = "^0.23"` (locked to 0.23.1) — visible verbatim in `/var/log/ebuild-updater-nightly.log` at the 03:08 UTC build attempt.

## Evidence

1. **`/var/log/ebuild-updater-nightly.log` (2026-09-26 03:08 UTC)**: `* ERROR: dev-util/mise-2026.9.14::haven-overlay failed (compile phase):` followed by `cargo build failed` and the diagnostic `error: failed to select a version for the requirement base64 = "^0.23" (locked to 0.23.1)`.
2. **`/var/log/ebuild-updater.log` (2026-09-26T03:54:38)**: the reinstall preflight *passed* (`emerge --pretend` returns 0 because cargo lockfile is opaque to portage), masking the failure from any pre-commit gate.
3. **Bump commit landed**: `git log --oneline` shows `dev-util/mise: bump to 2026.9.14` at `2026-09-26 03:12:28 +0100`. The bumped ebuild is now in `master`, in `profiles/package.accept_keywords` (or unkeyworded, either way reinstall must succeed for `@world`).
4. **Existing hold precedent** in `ebuild-updater.toml:48-63` — six phantom-crate holds with the exact same probe-evidence comment style. mise has not been added despite matching the pattern.
5. **No vault hit** for `mise cargo lockfile` in Cortex (search returned `[]`); the existing precedent in the config is sufficient evidence to extend the hold.

## Root Cause

`dev-util/mise` 2026.9.14's upstream `Cargo.lock` pins `base64` (and likely other crates) to versions not present on `static.crates.io`, so the offline `cargo build` cannot resolve dependencies and the bumped ebuild becomes unmergeable on this host. Same class as the six existing phantom-crate holds; mise was missed when the hold list was last extended.

## Blast Radius

- **`dev-util/mise`** itself: now unmergeable. Operators relying on `mise` for runtime version management cannot install the bumped version; the previous working version must be retained via `retention` until upstream regenerates the lockfile.
- **Other rust-native packages bumped recently**: `dev-util/rulesync`, `dev-util/opencode2`, `dev-util/opencode-plugin-safety-net`, `dev-util/oh-my-opencode-slim`, `dev-util/spec-kit`, `dev-util/superpowers`, `dev-util/mcp-grafana`, `dev-util/engram`, `dev-util/opencode-plugin-snippets`, `dev-util/golembot` — all bumped successfully today. They use `inherit cargo` or `cargo-build_src_compile` and *may* have similar lockfile drift. Out of scope for this change but worth a separate audit.
- **No other categories affected**: phantom-crate holds are rust-only.