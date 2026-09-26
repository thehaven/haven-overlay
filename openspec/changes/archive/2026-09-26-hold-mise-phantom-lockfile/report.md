## Symptom

The nightly `ebuild-updater` pipeline commits `dev-util/mise` 2026.9.14 (every bump lands cleanly) but the subsequent reinstall stage fails with `cargo build failed` against a `base64 = "^0.23"` constraint that resolves to 0.23.1 — a version mismatch between the locked `Cargo.lock` and the live registry. The bumped ebuild therefore becomes unmergeable offline.

## Environment

- haven-overlay (`/var/db/repos/haven-overlay`), branch `master`
- `ebuild-updater` nightly cron (`/etc/cron.daily/ebuild-updater`)
- Log: `/var/log/ebuild-updater-nightly.log` (844 KB today, 04:06 UTC last write)
- gentoo `portage` user, `FEATURES=userpriv`; `RESTRICT="network-sandbox"` does not apply (mise is rust-native, no `network-sandbox` flag)
- Live observation timestamp: `2026-09-26T03:08Z` (`dev-util/mise-2026.9.14::haven-overlay failed (compile phase)`)

## Reproduction Steps

1. Wait for the nightly cron (`/etc/cron.daily/ebuild-updater`) — bump stage commits `dev-util/mise-2026.9.14.ebuild` around 03:12 UTC.
2. Reinstall stage runs `emerge --pretend --ask=n -kg =dev-util/mise-2026.9.14` (per `ebuild_updater.reinstall` log) — preflight passes because cargo lockfile is opaque to portage.
3. Reinstall continues into `cargo build` (offline, no network) — fails: `error: failed to select a version for the requirement base64 = "^0.23" (locked to 0.23.1)` followed by `note: offline mode (via --offline) can sometimes cause surprising resolution failures`.

## Expected vs Actual

**Expected:** `ebuild-updater` should not commit a version that cannot be reinstalled on the same host that did the bump. This is the same failure mode as the six existing phantom-crate holds (`dev-python/ast-serialize`, `dev-python/jsonschema-rs`, `app-misc/tirith`, `dev-python/syntax-checker`, `dev-python/tree-sitter-language-pack`, `dev-util/agnix`) — those are pinned precisely because their `Cargo.lock` references crate versions that do not exist on `static.crates.io`.

**Actual:** mise joins the failure set. The commit lands at 03:12:28 UTC, the reinstall dies at 03:54:38 UTC, and the package is now permanently unmergeable until the upstream `Cargo.lock` is regenerated against versions that actually exist. Operator must either wait for an upstream lockfile fix or hand-edit the ebuild.

## Resolution

Fixed 2026-09-26 by this change. `dev-util/mise` added to the hold list at `ebuild-updater.toml:69` with a comment matching the existing six-entry phantom-crate block; TOML re-parsed cleanly. Tracking change `hold-mise-phantom-lockfile`; next nightly run will not propose a bump for mise.