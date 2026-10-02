# Tasks

## 0. Pre-existing bug fix

- [x] 0.1 opencode.jsonc: rename `rust-analyzer` → `rust` (close built-in double-spawn on .rs files) [smoke]

## 1. Tier 1 ebuilds (user-approved)

- [x] 1.1 dev-util/terraform-ls ebuild + opencode.jsonc wiring (override key `terraform`, HashiCorp CDN SRC_URI) [smoke]
- [x] 1.2 dev-util/ruby-lsp ebuild + opencode.jsonc wiring (override key `ruby-lsp`, gem-based) [smoke]
- [x] 1.3 dev-util/zls ebuild + opencode.jsonc wiring (override key `zls`, prebuilt tarball) [smoke]
- [ ] 1.4 dev-util/nixd ebuild + opencode.jsonc wiring (override key `nixd`, source build — CONDITIONAL on CI cost) [smoke]
- [x] 1.5 dev-util/phpactor ebuild + opencode.jsonc wiring (override key `php`, composer install) [smoke]
- [x] 1.6 dev-util/vue-language-server ebuild + opencode.jsonc wiring (override key `vue`, npm) [smoke]
- [x] 1.7 dev-util/astro-language-server ebuild + opencode.jsonc wiring (override key `astro`, npm; bin path `astro-ls`/`nodeServer.js`) [smoke]
- [x] 1.8 dev-util/lua-language-server ebuild + opencode.jsonc wiring (override key `lua-ls`, prebuilt tarball) [smoke]
- [ ] 1.9 dev-util/omnisharp-roslyn ebuild + opencode.jsonc wiring (override key `csharp`, 48-MiB tarball — CONDITIONAL on size) [smoke]
- [x] 1.10 dev-util/docker-langserver ebuild + opencode.jsonc wiring (override key `dockerfile`, npm; 224 Dockerfile variants) [smoke]

## 2. Tier 2 batch

- [x] 2.1 dev-util/prisma-language-server ebuild + opencode.jsonc wiring (override key `prisma`, npm) [smoke]

## 3. Final gate (disable linter LSPs + flag enable)

- [ ] 3.1 opencode.jsonc: disable built-in linter LSPs (eslint/oxlint/biome via `disabled: true`) [smoke]
- [ ] 3.2 .env: enable OPENCODE_DISABLE_LSP_DOWNLOAD=1 [smoke]
- [ ] 3.3 .env: ensure OPENCODE_EXPERIMENTAL_LSP_TY is **unset** (would switch pyright→ty and break config) [smoke]

## 4. Verification

- [ ] 4.1 Verify: zero entries in ~/.cache/opencode/ after opening files of every extension in the work area [integration]
- [ ] 4.2 Verify: `lsp.rust-analyzer` is renamed to `lsp.rust` (no double-spawn on .rs) [integration]

## 5. Documentation

- [ ] 5.1 AGENTS.md: document the lsp.* opencode.jsonc pattern (built-in id as key, command is String[], disabled: true to suppress) [smoke]

## Acceptance (locked at apply time)

- All Tier-1 ebuilds merged to master, `ebuild-updater --repo
  haven-overlay status` reports each as installed.
- opencode.jsonc `lsp` block has 8 (existing, with `rust-analyzer`
  renamed to `rust`) + 10 (Tier 1) + 1 (Tier 2) + 3 (linter
  disable) = 22 entries total; all keyed by BUILT-IN id; all
  using `command: String[]` syntax.
- Built-in LSP resolution path no longer triggers any GitHub/npm
  download for our work-area file extensions (`.py`/`.ts`/`.js`/
  `.vue`/`.astro`/`.rb`/`.zig`/`.zon`/`.cs`/`.nix`/`.lua`/`.php`/
  `.tf`/`Dockerfile`/`.rs`).
- `.env` carries `OPENCODE_DISABLE_LSP_DOWNLOAD=1`; does NOT
  carry `OPENCODE_EXPERIMENTAL_LSP_TY`.
- `openspec validate port-missing-language-servers --strict`
  exit 0.