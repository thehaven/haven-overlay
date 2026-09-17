# bun-slotting Specification

## Purpose
TBD - created by archiving change slot-bun-bin. Update Purpose after archive.

## Requirements

### Requirement: Slotted dev-lang/bun-bin Runtimes
`dev-lang/bun-bin` MUST support concurrent installation of multiple Bun minor releases (`1.3` and `1.4`) in separate Portage slots without file collisions.

- **Expected state:** 
  - `dev-lang/bun-bin-1.3.14` has `SLOT="1.3"` and installs `/usr/bin/bun-1.3` and `/usr/bin/bunx-1.3`.
  - `dev-lang/bun-bin-1.4.2` has `SLOT="1.4"` and installs `/usr/bin/bun-1.4` and `/usr/bin/bunx-1.4`.
  - Both packages can be emerged simultaneously without file collisions.
- **Verification command:** `equery l dev-lang/bun-bin` shows both `dev-lang/bun-bin-1.3.14:1.3` and `dev-lang/bun-bin-1.4.2:1.4` installed.
- **Rollback command:** `sudo emerge -C =dev-lang/bun-bin-1.4.2 && sudo emerge --oneshot =dev-lang/bun-bin-1.3.14` (with `SLOT="0"`).
- **Compliance tag:** `[INFRA]` `[SEC]`

#### Scenario: Installing Bun 1.3 and Bun 1.4 concurrently
- **WHEN** `emerge --oneshot dev-lang/bun-bin:1.3 dev-lang/bun-bin:1.4` is executed.
- **THEN** both binaries `/usr/bin/bun-1.3` and `/usr/bin/bun-1.4` exist and execute their respective versions (`1.3.14` and `1.4.2`).

---

### Requirement: Eselect Bun Module (app-eselect/eselect-bun)
An `eselect` module MUST be provided to manage the default interactive symlinks `/usr/bin/bun` and `/usr/bin/bunx` on the host system.

- **Expected state:** 
  - `/usr/share/eselect/modules/bun.eselect` is installed.
  - `eselect bun list` displays available `bun-1.*` binaries and marks the active target.
  - `eselect bun set <target>` updates `/usr/bin/bun` and `/usr/bin/bunx` symlinks atomically.
  - `eselect bun update ifunset` automatically initialises `/usr/bin/bun` if missing or broken during package postinst.
- **Verification command:** `eselect bun list && eselect bun show`
- **Rollback command:** `sudo rm -f /usr/share/eselect/modules/bun.eselect`
- **Compliance tag:** `[INFRA]`

#### Scenario: Switching interactive Bun version
- **WHEN** user executes `eselect bun set 1.3`.
- **THEN** `readlink /usr/bin/bun` points to `/usr/bin/bun-1.3` and `bun --version` reports `1.3.14`.
- **WHEN** user executes `eselect bun set 1.4`.
- **THEN** `readlink /usr/bin/bun` points to `/usr/bin/bun-1.4` and `bun --version` reports `1.4.2`.

---

### Requirement: Hermetic Eclass Build Isolation (bun.eclass)
`eclass/bun.eclass` MUST guarantee that all ebuild builds invoke the exact requested Bun version via an isolated `${T}/bun-bin` directory prepended to `PATH`, immune to interactive `eselect` state.

- **Expected state:**
  - `bun.eclass` defines `: "${BUN_SLOT:=1.3}"`.
  - `bun.eclass` sets `BDEPEND+=" dev-lang/bun-bin:${BUN_SLOT}"`.
  - `bun_pkg_setup` symlinks `${T}/bun-bin/bun` to `/usr/bin/bun-${BUN_SLOT}` and `${T}/bun-bin/bunx` to `/usr/bin/bunx-${BUN_SLOT}`.
  - `PATH` has `${T}/bun-bin` prepended before any `bun` commands or build scripts are executed.
- **Verification command:** `bun_pkg_setup` creates `${T}/bun-bin/bun` pointing to the intended slot; `bun --version` within any phase prints the exact `${BUN_SLOT}` version even if `eselect bun` is set to a different version.
- **Rollback command:** Revert `bun.eclass` changes via git.
- **Compliance tag:** `[INFRA]` `[CMP]`

#### Scenario: Deterministic compilation regardless of eselect default
- **WHEN** `eselect bun` is set to `1.4`, but `opencode-1.18.31` builds with `BUN_SLOT="1.3"`.
- **THEN** the ebuild builds using `/usr/bin/bun-1.3`, generating an uncorrupted binary that passes smoke tests.

---

### Requirement: OpenCode Release Line Slot Binding
`dev-util/opencode` (v1) and `dev-util/opencode2` (v2) MUST build from source against their respective required Bun toolchains.

- **Expected state:**
  - `dev-util/opencode` (1.18.x) builds using `dev-lang/bun-bin:1.3` without chunk-splitting runtime defects.
  - `dev-util/opencode2` (2.0.x) declares `BUN_SLOT="1.4"` and builds using `dev-lang/bun-bin:1.4`, satisfying upstream's `bun@^1.4.2` assertion.
  - Both binaries run cleanly side-by-side as `/usr/bin/opencode` and `/usr/bin/opencode2`.
- **Verification command:** 
  - `opencode run "reply with OK"` outputs `OK` (exit 0).
  - `opencode2 --version` outputs `opencode v2.0.6` (exit 0).
- **Rollback command:** `git restore` on the respective ebuilds.
- **Compliance tag:** `[INFRA]` `[CMP]`

#### Scenario: OpenCode 2 compile succeeds with Bun 1.4
- **WHEN** `emerge --oneshot =dev-util/opencode2-2.0.6` is run.
- **THEN** compilation succeeds without the `This script requires bun@^1.4.2` fatal error.
