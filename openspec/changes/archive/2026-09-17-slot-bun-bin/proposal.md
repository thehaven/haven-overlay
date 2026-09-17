# Infrastructure Change Proposal: Slotted Bun Toolchain (1.3 & 1.4)

## Change Summary

### Background & Problem
On 2026-09-17, `dev-lang/bun-bin` in `haven-overlay` was upgraded from `1.3.14` to `1.4.2`. This introduced an upstream chunk-splitting regression in Bun's bundler (`--splitting`) that causes cyclic module dependencies to evaluate as `undefined` at runtime.
When `dev-util/opencode-1.18.31` was compiled with Bun 1.4.2, all active OpenCode sessions crashed with:
```text
TypeError: undefined is not an object (evaluating 'a.name')
    at resolve (chunk-0kckh17n.js:2:1659)
    at SystemPrompt.environment (chunk-76fe9abw.js:50:13096)
```
Simultaneously, `dev-util/opencode2-2.0.6` (the OpenCode v2 beta release line) strictly mandates `bun@^1.4.2` at compile time in `packages/script/src/index.ts`. When compiled with Bun 1.3.14, it dies immediately with:
```text
error: This script requires bun@^1.4.2, but you are using bun@1.3.14
```
Because both packages previously shared an unslotted `dev-lang/bun-bin:0` installing directly to `/usr/bin/bun`, it was impossible to build both OpenCode release lines from source without manual toolchain flipping.

### Proposed Architecture
Implement Gentoo language slotting for `dev-lang/bun-bin`:
1. **Slotted `dev-lang/bun-bin`:** Slot into `1.3` and `1.4` (`SLOT="$(ver_cut 1-2)"`). Install versioned binaries `/usr/bin/bun-${SLOT}` and `/usr/bin/bunx-${SLOT}`.
2. **`app-eselect/eselect-bun`:** New eselect module providing user/system symlink management for interactive shells and shebang scripts (`/usr/bin/bun` -> active version).
3. **Hermetic Eclass Build Isolation:** Enhance `eclass/bun.eclass` with `BUN_SLOT` (defaulting to `"1.3"` for broad stability). In `bun_pkg_setup()`, prepend an isolated temporary directory `${T}/bun-bin` to `PATH` containing `bun -> /usr/bin/bun-${BUN_SLOT}`. This guarantees that ebuild compilation is hermetic and completely immune to whatever default the user has selected in `eselect bun`.
4. **Targeted Consumer Updates:**
   - `dev-util/opencode` (v1 line): builds hermetically with `bun-1.3`.
   - `dev-util/opencode2` (v2 line): declares `BUN_SLOT="1.4"`, building hermetically with `bun-1.4`.
   - All 55 other packages inheriting `bun.eclass` default safely to `BUN_SLOT="1.3"`.

## Affected Environments
* **Host environment:** Gentoo development workstation (`haven`), local Portage package database.
* **Repositories:** `haven-overlay` (`/var/db/repos/haven-overlay`).
* **Validation outside repository:** Validated that `/usr/portage` (`gentoo` main tree) and `/var/db/repos/gitlab-overlay` contain zero packages depending on `dev-lang/bun` or `dev-lang/bun-bin`. All consumers live entirely within `haven-overlay`.

## Rollback Strategy
If any unforeseen issue arises:
1. Revert `eclass/bun.eclass` to unslotted `BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"`.
2. Emerge `=dev-lang/bun-bin-1.3.14` with unslotted `SLOT="0"`.
3. Re-emerge `=dev-util/opencode-1.18.31`.

## Maintenance Window
* No downtime or maintenance window required.
* Running processes and existing compiled binaries (`/usr/bin/opencode`, `/usr/bin/opencode2`) are standalone self-contained ELF executables and will not be disrupted during the upgrade.
