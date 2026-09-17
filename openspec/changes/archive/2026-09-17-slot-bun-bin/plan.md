# Implementation Plan: Slotted Bun Toolchain

## Task 1.1 — Slot dev-lang/bun-bin-1.3.14

**Goal:** Modify `bun-bin-1.3.14.ebuild` to slot into `1.3`, install `/usr/bin/bun-1.3` and `/usr/bin/bunx-1.3`, and hook `eselect bun update ifunset`.  
**Files:** `dev-lang/bun-bin/bun-bin-1.3.14.ebuild`  
**Steps:**
1. Set `SLOT="$(ver_cut 1-2)"`.
2. Update `src_install`: `newbin "${bin}" "bun-${SLOT}"`, `dosym "bun-${SLOT}" "/usr/bin/bunx-${SLOT}"`.
3. Add `pkg_postinst` and `pkg_postrm`: call `eselect bun update ifunset`.
4. Run `ebuild dev-lang/bun-bin/bun-bin-1.3.14.ebuild manifest`.  
**Verify:** `ebuild dev-lang/bun-bin/bun-bin-1.3.14.ebuild compile` succeeds.  
**Commit:** `feat(dev-lang/bun-bin): slot 1.3.14 as SLOT="1.3"`

---

## Task 1.2 — Slot dev-lang/bun-bin-1.4.2

**Goal:** Modify `bun-bin-1.4.2.ebuild` to slot into `1.4`, install `/usr/bin/bun-1.4` and `/usr/bin/bunx-1.4`, and hook `eselect bun update ifunset`.  
**Files:** `dev-lang/bun-bin/bun-bin-1.4.2.ebuild`  
**Steps:**
1. Set `SLOT="$(ver_cut 1-2)"`.
2. Update `src_install`: `newbin "${bin}" "bun-${SLOT}"`, `dosym "bun-${SLOT}" "/usr/bin/bunx-${SLOT}"`.
3. Add `pkg_postinst` and `pkg_postrm`: call `eselect bun update ifunset`.
4. Run `ebuild dev-lang/bun-bin/bun-bin-1.4.2.ebuild manifest`.  
**Verify:** `ebuild dev-lang/bun-bin/bun-bin-1.4.2.ebuild compile` succeeds.  
**Commit:** `feat(dev-lang/bun-bin): slot 1.4.2 as SLOT="1.4"`

---

## Task 1.3 — Emerge both bun-bin slots

**Goal:** Concurrently install `dev-lang/bun-bin:1.3` and `dev-lang/bun-bin:1.4`.  
**Files:** System packages in `/var/db/pkg/dev-lang/`  
**Steps:**
1. Execute `sudo emerge --oneshot dev-lang/bun-bin:1.3 dev-lang/bun-bin:1.4`.  
**Verify:** `test -x /usr/bin/bun-1.3 && test -x /usr/bin/bun-1.4`  
**Commit:** N/A (system package state)

---

## Task 2.1 — Implement app-eselect/eselect-bun

**Goal:** Create `bun.eselect` module managing `/usr/bin/bun` and `/usr/bin/bunx`.  
**Files:** `app-eselect/eselect-bun/files/bun.eselect`  
**Steps:**
1. Implement `show_selected_target`, `find_targets`, `set_symlinks`, `remove_symlinks`.
2. Implement actions: `show`, `list`, `set`, and `update` (with `ifunset`).  
**Verify:** `bash -n app-eselect/eselect-bun/files/bun.eselect` syntax check passes.  
**Commit:** `feat(app-eselect/eselect-bun): add bun.eselect module`

---

## Task 2.2 — Create eselect-bun ebuild and emerge

**Goal:** Package and emerge `app-eselect/eselect-bun-0.1`.  
**Files:** `app-eselect/eselect-bun/eselect-bun-0.1.ebuild`, `metadata.xml`  
**Steps:**
1. Write ebuild installing `files/bun.eselect` to `/usr/share/eselect/modules/`.
2. Generate manifest with `ebuild ... manifest`.
3. Emerge via `sudo emerge --oneshot app-eselect/eselect-bun`.  
**Verify:** `eselect bun list` displays available slots.  
**Commit:** `feat(app-eselect/eselect-bun): initial package ebuild`

---

## Task 2.3 — Verify interactive symlink switching

**Goal:** Confirm user switching works cleanly.  
**Steps:**
1. Run `sudo eselect bun set 1.3 && bun --version`. Expect `1.3.14`.
2. Run `sudo eselect bun set 1.4 && bun --version`. Expect `1.4.2`.
3. Set default to `1.3` for baseline stability.  
**Verify:** `readlink /usr/bin/bun` reflects chosen target.  
**Commit:** N/A (validation)

---

## Task 3.1 & 3.2 — Update eclass/bun.eclass for Hermetic Build Isolation

**Goal:** Update `eclass/bun.eclass` so that all ebuilds build against their required `BUN_SLOT` via `${T}/bun-bin`, independent of `eselect`.  
**Files:** `eclass/bun.eclass`  
**Steps:**
1. Declare `: "${BUN_SLOT:=1.3}"`.
2. Set `BDEPEND+=" dev-lang/bun-bin:${BUN_SLOT}"`.
3. Implement `bun_pkg_setup` to populate `${T}/bun-bin` and prepend to `PATH`.
4. Add `pkg_setup` to `EXPORT_FUNCTIONS`.  
**Verify:** Test eclass in an ebuild subshell.  
**Commit:** `feat(eclass/bun): add BUN_SLOT and hermetic PATH wrapper`

---

## Task 4.1 & 4.2 — Configure OpenCode release lines

**Goal:** Bind `opencode` to `1.3` and `opencode2` to `1.4`.  
**Files:** `dev-util/opencode/opencode-1.18.31.ebuild`, `dev-util/opencode2/opencode2-2.0.6.ebuild`  
**Steps:**
1. In `opencode2-2.0.6.ebuild`, add `BUN_SLOT="1.4"`.
2. In `opencode-1.18.31.ebuild`, verify `BUN_SLOT="1.3"`.
3. Update manifests.  
**Verify:** `ebuild ... config` or manifest verification.  
**Commit:** `feat(dev-util/opencode2): bind to BUN_SLOT="1.4"`

---

## Task 4.3 — Audit remaining overlay packages

**Goal:** Verify that all other packages inheriting `bun.eclass` resolve cleanly to `BUN_SLOT="1.3"`.  
**Steps:** Run `emerge -pqv` on samples like `dev-util/oh-my-openagent` and `dev-util/opencode-plugin-safety-net`.  
**Verify:** No slot resolution errors or dependency cycles.  
**Commit:** N/A

---

## Task 4.4 & 4.5 — Full Smoke Testing of OpenCode 1 and OpenCode 2

**Goal:** Prove that both OpenCode release lines build from source and run without errors.  
**Steps:**
1. Emerge `dev-util/opencode-1.18.31`.
2. Run `opencode run "reply with OK"` and confirm `OK` (exit 0).
3. Emerge `dev-util/opencode2-2.0.6`.
4. Run `opencode2 --version` and confirm `opencode v2.0.6` (exit 0).  
**Verify:** Live commands return exit code 0.  
**Commit:** N/A
