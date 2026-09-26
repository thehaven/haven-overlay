## Hypothesis

The `hermes-plugin-*` family in `app-misc/` is an intentional monorepo split: a single upstream (`hermes`) packages into multiple atoms with distinct installed paths or distinct build targets (dashboard, disk-cleanup, example-dashboard, browser, …). The duplicate detector correctly identifies the cluster but, because no `[[duplicates.allow]]` entry exists and `policy = "hold"` is the default, every member except the canonical `hermes-plugin-browser` is held back and a per-sibling `WARNING` is logged on every nightly run. The warning text itself points at the fix: `resolve the duplicate or add [[duplicates.allow]]`.

## Evidence

1. **`/var/log/ebuild-updater.log:2026-09-26T03:37:47`** — three verbatim warning lines (log truncated by rotation for the other 12 siblings):
   ```
   WARNING  ebuild_updater.pipeline Skipping app-misc/hermes-plugin-dashboard: duplicate-upstream hold (sibling app-misc/hermes-plugin-browser); resolve the duplicate or add [[duplicates.allow]]
   WARNING  ebuild_updater.pipeline Skipping app-misc/hermes-plugin-disk-cleanup: duplicate-upstream hold (sibling app-misc/hermes-plugin-browser); resolve the duplicate or add [[duplicates.allow]]
   WARNING  ebuild_updater.pipeline Skipping app-misc/hermes-plugin-example-dashboard: duplicate-upstream hold (sibling app-misc/hermes-plugin-browser); resolve the duplicate or add [[duplicates.allow]]
   ```
1a. **`ebuild-updater duplicates --json`** (2026-09-26): the cluster contains exactly **16 atoms** (15 siblings + canonical `hermes-plugin-browser`); severity `error`; kind `github+target`; shared `github_repo=github:NousResearch/hermes-agent`; shared `build_target=hermes-agent-2026.5.7`; `allowed: false`.
2. **`/etc/ebuild-updater/config.toml.example:165-186`** documents the `[[duplicates.allow]]` table syntax: `atoms` (list), optional `upstream` (guard against copy-paste after rename), and `reason` (≥10 characters, otherwise config-load error).
3. **`fix-ebuild-bump-failures` precedent** (`openspec/changes/fix-ebuild-bump-failures/`) demonstrates the same fix pattern — surface the upstream issue in `investigation.md`, add a config stanza that documents the cluster, verify with `ebuild-updater status`.
4. **No vault hit** in Cortex for `hermes plugin duplicates monorepo`; the warning text and config.example are sufficient evidence to add the entry.
5. **`ebuild-updater duplicates --json`** (per `config.toml.example:167`) lists every unapproved cluster; running it before and after the change is the regression test for this fix.

## Root Cause

No `[[duplicates.allow]]` entry exists in `/etc/ebuild-updater/config.toml` for the `hermes-plugin-*` cluster, so the duplicate detector's default `policy = "hold"` causes the bump stage to skip every sibling atom on every nightly run and emit a per-sibling warning. The siblings are intentional (monorepo split), so the correct fix is to add an allow entry naming the cluster with a non-trivial `reason`.

## Blast Radius

- **All 14 `hermes-plugin-*` siblings**: stop being held, start bumping on their normal cadence. Any of them that has upstream changes will now commit on the next nightly run.
- **`hermes-plugin-browser`** (canonical): unaffected — already bumping.
- **Other duplicate clusters**: out of scope for this change. The fix is bounded to the `hermes-plugin-*` family; if `ebuild-updater duplicates --json` surfaces other clusters after the change, they get their own change.
- **No other categories affected**: the change only touches one TOML table entry.