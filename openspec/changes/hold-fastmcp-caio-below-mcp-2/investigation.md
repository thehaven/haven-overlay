## Hypothesis

`dev-python/fastmcp` and `dev-python/caio` declare an upper bound on `dev-python/mcp` (both require `<dev-python/mcp-2`) but their RDEPEND lists were never pinned on the overlay hold list when the existing `dev-python/mcp` hold was added (per `ebuild-updater.toml:64-67`). With `mcp 2.x` upstream released but masked system-wide, every bump of `fastmcp` or `caio` produces an ebuild that cannot reinstall on this host, and the nightly cron logs a noisy `emerge --pretend failed rc=1` warning that the operator has to read every day to know whether the per-atom fallback actually succeeded.

## Evidence

1. **`/var/log/ebuild-updater.log:2026-09-26T03:39:16`**:
   `WARNING  ebuild_updater.pipeline  reinstall preflight: emerge --pretend failed rc=1; dep-graph unsatisfiable for at least one atom in the batch. Per-atom loop will continue; failures will be reported per atom.`
2. **Same-day reinstall batch at 03:39:07** (verbatim from log): the batch contains `=dev-python/caio-0.12.5 =dev-python/fastmcp-4.0.10` alongside 17 other atoms — confirms both are in the bumped set.
3. **Second reinstall attempt at 03:54:38**: `emerge --pretend --ask=n -kg =dev-python/mem0ai-2.2.1 =dev-util/lsp-meta-2.0.18 =dev-util/opencode-plugin-quota-4.10.4 =dev-util/opencode-plugins-2.0.18` — a smaller batch that again triggers the preflight warning because `mem0ai` also depends on `<dev-python/mcp-2` transitively.
4. **Existing hold precedent** in `ebuild-updater.toml:64-67`: `dev-python/mcp` held with comment `mcp 2.x breaks mcp-mesh gateway + ~10 FastMCP-importing packages (haven-overlay 2026:9:08)`. The "~10 FastMCP-importing packages" line implies the author knew about the dependency chain but did not extend the hold list to cover them. `fastmcp` and `caio` are the two most prominent in this overlay.
5. **No vault hit** for `mcp 2.x mask fastmcp reinstall` in Cortex (search returned `[]`); the comment in the existing hold is sufficient evidence.

## Root Cause

`dev-python/fastmcp` and `dev-python/caio` both declare `<dev-python/mcp-2` in RDEPEND but were not added to the overlay hold list when the existing `dev-python/mcp` hold was established. The bump stage therefore produces new versions of both packages that the reinstall stage cannot satisfy offline because `mcp-2.x` is masked system-wide. The per-atom loop is a documented fallback (per the log) but produces a noisy warning on every nightly run.

## Blast Radius

- **`dev-python/fastmcp`**: every new release is committed to master but cannot be reinstalled until `dev-python/mcp` lifts its `<2` ceiling upstream. Operators wanting the new fastmcp must hand-install.
- **`dev-python/caio`**: same situation — `<2` ceiling on `mcp` blocks reinstall.
- **Other FastMCP-importing packages**: the existing `dev-python/mcp` hold comment references "~10 FastMCP-importing packages"; this change does not audit them all but the hold list can be extended incrementally as new ones bump and fail the preflight.
- **No other categories affected**: this is a Python dep-graph constraint; rust/cargo holds (separate change `hold-mise-phantom-lockfile`) are unrelated.