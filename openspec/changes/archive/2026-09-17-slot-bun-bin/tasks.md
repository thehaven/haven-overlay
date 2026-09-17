# Implementation Tasks: Slotted Bun Toolchain

## 1. Slotted dev-lang/bun-bin Implementation

- [x] 1.1 Update `dev-lang/bun-bin-1.3.14.ebuild` to `SLOT="1.3"`, install versioned `/usr/bin/bun-1.3` and `/usr/bin/bunx-1.3`, and add `eselect bun update ifunset` in postinst/postrm [spec: Slotted dev-lang/bun-bin Runtimes] [smoke]
- [x] 1.2 Update `dev-lang/bun-bin-1.4.2.ebuild` to `SLOT="1.4"`, install versioned `/usr/bin/bun-1.4` and `/usr/bin/bunx-1.4`, and add `eselect bun update ifunset` in postinst/postrm [spec: Slotted dev-lang/bun-bin Runtimes] [smoke]
- [x] 1.3 Update Manifests and emerge both `dev-lang/bun-bin:1.3` and `dev-lang/bun-bin:1.4` [spec: Slotted dev-lang/bun-bin Runtimes] [integration]

## 2. Eselect Bun Module Implementation

- [x] 2.1 Create `app-eselect/eselect-bun/files/bun.eselect` providing `list`, `show`, `set`, and `update` actions for `/usr/bin/bun` and `/usr/bin/bunx` [spec: Eselect Bun Module] [unit]
- [x] 2.2 Create `app-eselect/eselect-bun/eselect-bun-0.1.ebuild`, digest Manifest, and emerge it [spec: Eselect Bun Module] [integration]
- [x] 2.3 Verify `eselect bun list`, `eselect bun show`, and symlink toggling between 1.3 and 1.4 [spec: Eselect Bun Module] [smoke]

## 3. Hermetic Eclass Build Isolation

- [x] 3.1 Update `eclass/bun.eclass` to define `: "${BUN_SLOT:=1.3}"`, set `BDEPEND+=" dev-lang/bun-bin:${BUN_SLOT}"`, and implement `bun_pkg_setup` with `${T}/bun-bin` wrapper [spec: Hermetic Eclass Build Isolation] [unit]
- [x] 3.2 Update `EXPORT_FUNCTIONS` in `eclass/bun.eclass` to export `pkg_setup src_compile src_install` [spec: Hermetic Eclass Build Isolation] [unit]

## 4. Dependent Package Binding & Smoke Testing

- [x] 4.1 Update `dev-util/opencode/opencode-1.18.31.ebuild` to verify `BUN_SLOT="1.3"` binding [spec: OpenCode Release Line Slot Binding] [unit]
- [x] 4.2 Update `dev-util/opencode2/opencode2-2.0.6.ebuild` to declare `BUN_SLOT="1.4"` [spec: OpenCode Release Line Slot Binding] [unit]
- [x] 4.3 Audit all remaining packages in `haven-overlay` inheriting `bun.eclass` to ensure default `BUN_SLOT="1.3"` compatibility [spec: Hermetic Eclass Build Isolation] [integration]
- [x] 4.4 Re-emerge `dev-util/opencode-1.18.31` and smoke test live model execution with `opencode run "reply with OK"` [spec: OpenCode Release Line Slot Binding] [smoke]
- [x] 4.5 Emerge `dev-util/opencode2-2.0.6` from source with Bun 1.4 and smoke test `opencode2 --version` [spec: OpenCode Release Line Slot Binding] [smoke]
