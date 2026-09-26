## Symptom

Every nightly `ebuild-updater` run logs `reinstall preflight: emerge --pretend failed rc=1; dep-graph unsatisfiable for at least one atom in the batch` followed by `Per-atom loop will continue; failures will be reported per atom`. The unsatisfiable atom is the install of `dev-python/fastmcp-4.0.10` (and `dev-python/caio-0.12.5`): both require `<dev-python/mcp-2` but `dev-python/mcp-2.x` exists upstream and is masked via `/etc/portage/package.mask` plus the overlay's existing `dev-python/mcp` hold. The reinstall stage therefore cannot complete the batch, but the per-atom fallback loop still installs the rest — meaning the warning fires nightly, the build log is noisy, and the operator has no signal whether the per-atom install actually succeeded for the masked-conflict atoms.

## Environment

- haven-overlay, branch `master`
- `ebuild-updater` nightly cron (`/etc/cron.daily/ebuild-updater`)
- Log: `/var/log/ebuild-updater.log` (INFO + WARNING lines), last line at `2026-09-26T03:54:38Z`
- gentoo `portage` user, system `package.mask` blocks `>=dev-python/mcp-2.0.0` until the gateway package upgrades
- Existing hold precedent in `ebuild-updater.toml:64-67`: `dev-python/mcp` is already held with the comment `mcp 2.x breaks mcp-mesh gateway + ~10 FastMCP-importing packages (haven-overlay 2026:9:08)`

## Reproduction Steps

1. Wait for (or manually invoke) the nightly `ebuild-updater pipeline`.
2. After the bump stage commits `dev-python/fastmcp-4.0.10` and `dev-python/caio-0.12.5` (typical: ~03:10 UTC, see today's log), the reinstall stage runs `emerge --pretend --ask=n -kg` over the batch.
3. `emerge --pretend` returns rc=1 because the batch includes atoms whose dep graph transitively requires `>=dev-python/mcp-2` — masked by both `/etc/portage/package.mask` and the overlay's `dev-python/mcp` hold.
4. The pipeline logs `WARNING ... reinstall preflight ... failed with rc=1` and falls back to a per-atom loop. The per-atom loop installs everything that *can* install; the masked-conflict atoms get an individual `emerge --pretend` and silently fall through.

## Expected vs Actual

**Expected:** either (a) the masked-conflict atoms are pinned on the hold list so the bump stage stops trying to advance them past the constraint, OR (b) the operator accepts the per-atom fallback and the warning is downgraded to info-level. Either way, the cron log should not look like a regression on every run.

**Actual:** the warning fires every run. Today (2026-09-26) it has fired twice already (03:39:16 and 03:54:38). The overlay's existing `dev-python/mcp` hold documents the same constraint class but did not anticipate that `fastmcp` and `caio` would also be capped by it — they should have been added at the same time.

## Resolution

Fixed 2026-09-26 by this change. `dev-python/fastmcp` and `dev-python/caio` added to the hold list at `ebuild-updater.toml:77-78` with a comment explaining the `<dev-python/mcp-2` ceiling shared with the existing `dev-python/mcp` hold; TOML re-parsed cleanly. Next nightly run will not propose a bump for either atom, and the reinstall preflight batch will no longer include the masked-conflict atoms. Tracking change `hold-fastmcp-caio-below-mcp-2`.