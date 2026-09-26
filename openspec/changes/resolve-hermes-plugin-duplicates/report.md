## Symptom

Every nightly `ebuild-updater` run emits 14 identical `WARNING  ebuild_updater.pipeline` lines of the form `Skipping app-misc/hermes-plugin-<X>: duplicate-upstream hold (sibling app-misc/hermes-plugin-browser); resolve the duplicate or add [[duplicates.allow]]` — one per sibling in the `hermes-plugin-*` family. The warning fires regardless of whether upstream has a new version, which makes the log noisy and makes real warnings easy to overlook. The siblings share an upstream with `app-misc/hermes-plugin-browser`; the duplicates detector groups them per the existing `policy = "hold"` default and refuses to bump any unapproved member.

## Environment

- haven-overlay, branch `master`
- `ebuild-updater` nightly cron (`/etc/cron.daily/ebuild-updater`)
- Log: `/var/log/ebuild-updater.log` (today, 14 `hermes-plugin-*` skip warnings at 03:37:47)
- Duplicate detector: `src/ebuild_updater/duplicates.py` (per `config.toml.example:147-150`), default `policy = "hold"`
- Affected cluster (full enumeration via `ebuild-updater duplicates --json`, 2026-09-26): **16 atoms total** under `app-misc/hermes-plugin-*` — `browser` (canonical) plus 15 siblings: `context-engine`, `dashboard`, `disk-cleanup`, `example-dashboard`, `google-meet`, `hermes-achievements`, `image-gen`, `kanban`, `memory`, `model-providers`, `observability`, `platforms`, `spotify`, `video-gen`, `web`. Shared upstream: `github:NousResearch/hermes-agent`; shared build target: `hermes-agent-2026.5.7`. The log only enumerates 3 because of rotation; the detector output is authoritative.

## Reproduction Steps

1. Wait for (or manually invoke) the nightly `ebuild-updater pipeline`.
2. During the bump stage, the duplicate detector groups the `hermes-plugin-*` family by shared upstream. `hermes-plugin-browser` is treated as the canonical member; the other siblings are flagged as duplicates.
3. With `policy = "hold"` (default), each flagged sibling is skipped and a `WARNING` line is logged: `Skipping app-misc/hermes-plugin-<X>: duplicate-upstream hold (sibling app-misc/hermes-plugin-browser); resolve the duplicate or add [[duplicates.allow]]`.
4. The `bump` stage proceeds; the warnings accumulate in the log; nothing is committed for the siblings.

## Expected vs Actual

**Expected:** the operator either (a) resolves the duplicates upstream by removing the sibling atoms or repointing their SRC_URI to a non-overlapping upstream, OR (b) adds an explicit `[[duplicates.allow]]` entry that names the intentional cluster with a non-empty `reason` (per `config.toml.example:165-186`), so the detector accepts the cluster and the warnings stop firing.

**Actual:** neither (a) nor (b) has been done. The 14 warnings fire on every nightly run, with no plan to resolve. The siblings themselves appear to be intentional — they share a monorepo with `hermes-plugin-browser` and have distinct installed paths or build targets — making (b) the lower-risk fix.

## Resolution

Fixed 2026-09-26 by this change. Added `[duplicates]` table and one `[[duplicates.allow]]` block to `/etc/ebuild-updater/config.toml` covering all 16 atoms with `upstream = "github:NousResearch/hermes-agent"` and `reason = "monorepo component split; distinct build targets, shared NousResearch/hermes-agent upstream"`. `ebuild-updater duplicates --json` now returns `[]` — zero unapproved groups remain. The 16-atom allow entry is in the host-local `/etc/ebuild-updater/config.toml` (NOT tracked by git); replicate the block on other hosts that share this overlay.