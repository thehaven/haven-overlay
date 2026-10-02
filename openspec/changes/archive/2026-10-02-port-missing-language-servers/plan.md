# Plan

Each Tier-1 task group is sized for a single independent commit
(≤200 LOC per task; 1 ebuild + 1 opencode.jsonc patch + 1 metadata
entry per group).

Ebuild-strategy classes (verified 2026-10-01):

- **Go binary tarball (HashiCorp CDN)** — `terraform-ls`. SRC_URI:
  `https://releases.hashicorp.com/terraform-ls/${PV}/terraform-ls_${PV}_linux_amd64.zip`.
  Reference: terraform-ls release page currently publishes
  `0.10.0`; GitHub tag `v0.39.0` is the last GitHub-released version
  before migration to HashiCorp CDN and is **stale**. Use CDN
  numbering. SHA256SUMS at
  `terraform-ls_${PV}_SHA256SUMS` (signed by HashiCorp).
- **Ruby gem** — `ruby-lsp`. Uses `ruby-ng` / `ruby-fakegem` eclass
  (gem provides language-server executable via rubygems
  `executables` API).
- **Prebuilt Rust binary tarball** — `zls`. SRC_URI:
  `https://github.com/zigtools/zls/releases/download/${PV}/zls-x86_64-linux.tar.xz`.
  Verified: `0.16.0` ships prebuilt `zls` binary.
- **Rust source build** — `nixd`. SRC_URI: github archive + cargo
  vendor (no prebuilt). Heavy; flag as conditional — defer if
  build cost too high in CI.
- **Composer install** — `phpactor`. Composer package (NOT PHAR).
  Ebuild wraps `composer install` and installs vendor binaries.
- **npm package** — `vue-language-server`, `astro-language-server`,
  `prisma-language-server`, `docker-langserver`. Use overlay
  `eclass/npm.eclass` (see existing
  `dev-util/bash-language-server/`, `dev-util/typescript-language-server/`
  for patterns). Note the **bin name**: `astro-ls` (not
  `astro-language-server`).
- **Prebuilt Lua/C++ binary tarball** — `lua-language-server`.
  SRC_URI:
  `https://github.com/LuaLS/lua-language-server/releases/download/${PV}/lua-language-server-${PV}-linux-x64.tar.gz`.
  Verified: `3.19.1` ships `linux-x64.tar.gz` (3.5 MiB).
- **Prebuilt mono/Roslyn binary tarball** — `omnisharp-roslyn`.
  SRC_URI:
  `https://github.com/OmniSharp/omnisharp-roslyn/releases/download/v${PV}/omnisharp-linux-x64.tar.gz`.
  Verified: `v2.0.0` ships `omnisharp-linux-x64.tar.gz` (48 MiB).
  Heavy; flag as conditional — `csharp` LSP can also use Roslyn
  (.NET install script via opencode's built-in) but that path is
  even heavier.

Every task must reference a specific upstream release tag, verify
SHA256 against the upstream release manifest, and produce a
`Manifest` that matches.

---

## Task 0.1 — opencode.jsonc: rename `rust-analyzer` to `rust`

**Goal:** Close the hidden double-spawn on `.rs` files. Independent
of portage work; lands first.

**Files:**
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Change `"rust-analyzer":` (line 166) to `"rust":`.
2. Keep the same `command`/`extensions` body.
3. The merge logic in `lsp.ts:165-179` will now match
   `servers["rust"]` (the built-in) and REPLACE its `spawn`. Built-in
   downloader no longer fires.
4. Smoke: open a `.rs` file in opencode; confirm only ONE LSP client
   spawned (the user's, pointing at `/usr/bin/rust-analyzer`); no
   entry in `~/.cache/opencode/`.

**Verify:** `grep -nE '^\s+"(rust|rust-analyzer)":' opencode.jsonc`
returns `"rust":` only; `which rust-analyzer` → `/usr/bin/rust-analyzer`
(via `nice`); no `.rs` open triggers `github.com/rust-lang/rust-analyzer`
download.

**Commit:** `opencode.jsonc: rename rust-analyzer → rust (close built-in double-spawn)`

---

## Task 1.1 — dev-util/terraform-ls ebuild + wiring

**Goal:** `dev-util/terraform-ls-<v>.ebuild` lands in master;
`lsp.terraform.command` in opencode.jsonc points at the portage
binary; `emerge --oneshot dev-util/terraform-ls` resolves, `which
terraform-ls` → `/usr/bin/terraform-ls`.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/terraform-ls/terraform-ls-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/terraform-ls/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/terraform-ls/Manifest` (new, generated)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Pick `<v>` from
   `https://releases.hashicorp.com/terraform-ls/index.json`
   (current latest: `0.10.0`). **Do not** use the GitHub tag
   (`v0.39.0`) — that is the last GitHub-released version before
   migration to the HashiCorp CDN and is stale.
2. Author the ebuild following the `dev-util/rust-analyzer` pattern
   in this overlay (binary tarball + SHA256 SRC_URI + LICENSE= +
   `SLOT="0"` + `KEYWORDS="~amd64"`). SRC_URI:
   `https://releases.hashicorp.com/terraform-ls/${PV}/terraform-ls_${PV}_linux_amd64.zip`.
3. `sudo -n ebuild dev-util/terraform-ls/terraform-ls-<v>.ebuild
   manifest`; commit the generated `Manifest`.
4. Add to opencode.jsonc `lsp` block (override key = built-in id
   `terraform`, NOT the package name):
   ```json
   "terraform": {
     "command": ["/usr/bin/terraform-ls"],
     "extensions": ["tf", "tfvars"]
   }
   ```
5. `sudo -n emerge --oneshot '=dev-util/terraform-ls-<v>'`.
6. Smoke-test: open any `.tf` file; confirm no GitHub download
   attempt.

**Verify:** `equery l dev-util/terraform-ls` shows installed;
`emerge --pretend '=dev-util/terraform-ls-<v>'` exits 0;
`lsp.terraform.command` in config; no entry in `~/.cache/opencode/`
after opening a `.tf` file.

**Commit:** `dev-util/terraform-ls: add ebuild + opencode.jsonc wiring`

---

## Task 1.2 — dev-util/ruby-lsp ebuild + wiring

**Goal:** Ruby LSP server available portage-side; opencode `.rb`
files use the portage binary, not a GitHub download.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/ruby-lsp/ruby-lsp-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/ruby-lsp/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/ruby-lsp/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Pin `<v>` from
   `https://rubygems.org/api/v1/gems/ruby-lsp.json` (current:
   `0.26.11`). ruby-lsp is a Ruby gem; the language-server
   binary is installed via `gem install`.
2. Ebuild uses `ruby-fakegem` or `ruby-ng` eclass. RDEPEND on
   `dev-lang/ruby` (already in tree).
3. Add to opencode.jsonc (override key matches built-in id
   `ruby-lsp`):
   ```json
   "ruby-lsp": {
     "command": ["ruby-lsp"],
     "extensions": ["rb", "rake", "ru"]
   }
   ```
   Note: built-in extensions list (line 395) is `[".rb", ".rake",
   ".ru"]`. We could include `.gemspec` too — verify upstream
   server supports it (opencode does not include `.gemspec` in
   built-in list; defer adding to avoid breaking behaviour).
4. `sudo -n emerge --oneshot '=dev-util/ruby-lsp-<v>'`.
5. Smoke: open a `.rb` file; no download attempt; LSP works.

**Verify:** `equery l dev-util/ruby-lsp` shows installed; gem
provides `/usr/bin/ruby-lsp`; `lsp.ruby-lsp.command` in config.

**Commit:** `dev-util/ruby-lsp: add ebuild + opencode.jsonc wiring`

---

## Task 1.3 — dev-util/zls ebuild + wiring

**Goal:** Zig language server; `.zig`/`.zon` files get LSP features
without GitHub download.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/zls/zls-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/zls/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/zls/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Pin `<v>` from
   `https://api.github.com/repos/zigtools/zls/releases/latest`
   (current: `0.16.0`). Asset name:
   `zls-x86_64-linux.tar.xz`.
2. Unpack prebuilt Linux/amd64 binary into `${D}/usr/bin/zls`.
   LICENSE=MIT.
3. Add to opencode.jsonc (override key matches built-in id `zls`):
   ```json
   "zls": {
     "command": ["/usr/bin/zls"],
     "extensions": ["zig", "zon"]
   }
   ```
4. `sudo -n emerge --oneshot '=dev-util/zls-<v>'`.
5. Smoke: open `.zig`; no download.

**Verify:** `equery l dev-util/zls`; `which zls` → `/usr/bin/zls`;
`lsp.zls.command` in config.

**Commit:** `dev-util/zls: add ebuild + opencode.jsonc wiring`

---

## Task 1.4 — dev-util/nixd ebuild + wiring (CONDITIONAL)

**Goal:** Nix language server; `.nix` files use portage binary.
**CONDITIONAL**: skip this task if cargo build too expensive in
CI; otherwise defer to Tier 2.

**Files (if proceeded):**
- `/var/db/repos/haven-overlay/dev-util/nixd/nixd-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/nixd/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/nixd/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps (if proceeded):**
1. Pin `<v>` from
   `https://api.github.com/repos/nix-community/nixd/releases/latest`
   (current: `2.9.3`). nixd ships NO GitHub release binaries; SRC_URI
   must be the GitHub tarball.
2. Ebuild inherits `cargo` eclass; BDEPEND on `virtual/rust`.
   RDEPEND on `dev-lang/nix` (or `nix` binary outside portage, in
   which case nixd's runtime requirement on Nix itself is satisfied
   by the host install).
3. Add to opencode.jsonc (override key matches built-in id `nixd`):
   ```json
   "nixd": {
     "command": ["/usr/bin/nixd"],
     "extensions": ["nix"]
   }
   ```
4. `sudo -n emerge --oneshot '=dev-util/nixd-<v>'` (may take 5+
   minutes for cargo build).
5. Smoke: open `.nix`; no download.

**Verify:** `equery l dev-util/nixd`; `which nixd` → `/usr/bin/nixd`;
`lsp.nixd.command` in config.

**Commit:** `dev-util/nixd: add ebuild + opencode.jsonc wiring`

---

## Task 1.5 — dev-util/phpactor ebuild + wiring

**Goal:** PHP language server; `.php` files use portage binary.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/phpactor/phpactor-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/phpactor/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/phpactor/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Pin `<v>` from
   `https://api.github.com/repos/phpactor/phpactor/releases/latest`.
2. phpactor is a Composer package (NOT a PHAR). Ebuild wraps
   `composer install`; install path: `${D}/usr/share/phpactor` +
   wrapper script `/usr/bin/phpactor`. RDEPEND on
   `dev-lang/php:7.4+`.
3. Add to opencode.jsonc (override key matches built-in id `php`):
   ```json
   "php": {
     "command": ["/usr/bin/phpactor"],
     "extensions": ["php"]
   }
   ```
4. `sudo -n emerge --oneshot '=dev-util/phpactor-<v>'`.
5. Smoke: open `.php`; no download.

**Verify:** `equery l dev-util/phpactor`; `which phpactor`;
`lsp.php.command` in config.

**Commit:** `dev-util/phpactor: add ebuild + opencode.jsonc wiring`

---

## Task 1.6 — dev-util/vue-language-server ebuild + wiring

**Goal:** Vue language server; `.vue` files use portage binary.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/vue-language-server/vue-language-server-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/vue-language-server/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/vue-language-server/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Pin `<v>` from
   `curl -sL https://registry.npmjs.org/@vue/language-server/latest | jq .version`
   (current: `3.3.11`).
2. Ebuild uses `eclass/npm.eclass`; SRC_URI points at npm tarball
   (`https://registry.npmjs.org/@vue/language-server/-/language-server-<v>.tgz`).
   RDEPEND on `net-libs/nodejs` (in tree).
3. Add to opencode.jsonc (override key matches built-in id `vue`,
   NOT `vue-language-server`):
   ```json
   "vue": {
     "command": ["node", "/usr/lib64/node_modules/@vue/language-server/bin/vue-language-server.js"],
     "extensions": ["vue"]
   }
   ```
   Use absolute paths for both `node` and the script, matching the
   existing `bash`/`typescript`/`yaml-ls` config patterns.
4. `sudo -n emerge --oneshot '=dev-util/vue-language-server-<v>'`.
5. Smoke: open `.vue`; no download.

**Verify:** `equery l dev-util/vue-language-server`;
`lsp.vue.command` in config; no entry in `~/.cache/opencode/`.

**Commit:** `dev-util/vue-language-server: add ebuild + opencode.jsonc wiring`

---

## Task 1.7 — dev-util/astro-language-server ebuild + wiring

**Goal:** Astro language server; `.astro` files use portage binary.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/astro-language-server/astro-language-server-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/astro-language-server/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/astro-language-server/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Pin `<v>` from
   `curl -sL https://registry.npmjs.org/@astrojs/language-server/latest | jq .version`
   (current: `2.17.1`).
2. Ebuild uses `eclass/npm.eclass`. Same wiring pattern as
   Task 1.6.
3. Add to opencode.jsonc (override key matches built-in id
   `astro`, NOT `astro-language-server`):
   ```json
   "astro": {
     "command": ["node", "/usr/lib64/node_modules/@astrojs/language-server/bin/nodeServer.js"],
     "extensions": ["astro"]
   }
   ```
   **Note bin name is `astro-ls` per npm registry's `bin` field, but
   the executable script in the tarball is `bin/nodeServer.js`.**
   Verify path by extracting tarball and inspecting `package.json`
   `bin` field.
4. `sudo -n emerge --oneshot`.
5. Smoke: open `.astro`; no download.

**Verify:** `equery l dev-util/astro-language-server`;
`lsp.astro.command` in config.

**Commit:** `dev-util/astro-language-server: add ebuild + opencode.jsonc wiring`

---

## Task 1.8 — dev-util/lua-language-server ebuild + wiring

**Goal:** Lua language server; `.lua` files (41 in work area) get
LSP features without GitHub download.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/lua-language-server/lua-language-server-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/lua-language-server/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/lua-language-server/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Pin `<v>` from
   `https://api.github.com/repos/LuaLS/lua-language-server/releases/latest`
   (current: `3.19.1`). Asset name:
   `lua-language-server-3.19.1-linux-x64.tar.gz` (3.5 MiB).
2. Unpack prebuilt Linux/x64 binary into `${D}/usr/bin/lua-language-server`.
3. Add to opencode.jsonc (override key matches built-in id
   `lua-ls`, NOT `lua-language-server`):
   ```json
   "lua-ls": {
     "command": ["/usr/bin/lua-language-server"],
     "extensions": ["lua"]
   }
   ```
4. `sudo -n emerge --oneshot`.
5. Smoke: create a trivial `.lua` file; open; no download.

**Verify:** `equery l dev-util/lua-language-server`;
`lsp.lua-ls.command` in config.

**Commit:** `dev-util/lua-language-server: add ebuild + opencode.jsonc wiring`

---

## Task 1.9 — dev-util/omnisharp-roslyn ebuild + wiring (CONDITIONAL)

**Goal:** C# language server; `.cs` files use portage binary.
**CONDITIONAL**: skip if 48-MiB download + runtime overhead too
costly; otherwise proceed.

**Files (if proceeded):**
- `/var/db/repos/haven-overlay/dev-util/omnisharp-roslyn/omnisharp-roslyn-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/omnisharp-roslyn/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/omnisharp-roslyn/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps (if proceeded):**
1. Pin `<v>` from
   `https://api.github.com/repos/OmniSharp/omnisharp-roslyn/releases/latest`
   (current: `v2.0.0`). Asset name:
   `omnisharp-linux-x64.tar.gz` (48 MiB).
2. Unpack into `${D}/usr/share/omnisharp` + wrapper at
   `/usr/bin/omnisharp-roslyn` calling the unpacked binary.
   RDEPEND optional on `dev-lang/mono` for older runtimes; OmniSharp
   v2.0.0 is self-contained.
3. Add to opencode.jsonc (override key matches built-in id `csharp`,
   NOT `omnisharp-roslyn`):
   ```json
   "csharp": {
     "command": ["/usr/bin/omnisharp-roslyn"],
     "extensions": ["cs", "csx"]
   }
   ```
4. `sudo -n emerge --oneshot`.
5. Smoke: open `.cs`; no download.

**Verify:** `equery l dev-util/omnisharp-roslyn`;
`lsp.csharp.command` in config.

**Commit:** `dev-util/omnisharp-roslyn: add ebuild + opencode.jsonc wiring`

---

## Task 1.10 — dev-util/docker-langserver ebuild + wiring

**Goal:** Dockerfile LSP; `.dockerfile` and `Dockerfile` variants
(224 in work area) use portage binary.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/docker-langserver/docker-langserver-<v>.ebuild` (new)
- `/var/db/repos/haven-overlay/dev-util/docker-langserver/metadata.xml` (new)
- `/var/db/repos/haven-overlay/dev-util/docker-langserver/Manifest` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Pin `<v>` from
   `curl -sL https://registry.npmjs.org/dockerfile-language-server/latest | jq .version`.
2. Ebuild uses `eclass/npm.eclass`; SRC_URI:
   `https://registry.npmjs.org/dockerfile-language-server/-/dockerfile-language-server-<v>.tgz`.
   RDEPEND on `net-libs/nodejs`.
3. Add to opencode.jsonc (override key matches built-in id
   `dockerfile`, NOT `docker-langserver`):
   ```json
   "dockerfile": {
     "command": ["node", "/usr/lib64/node_modules/dockerfile-language-server/bin/docker-langserver.js"],
     "extensions": ["dockerfile", "Dockerfile", "Containerfile"]
   }
   ```
   Verify `extensions` list against opencode built-in (line 1776)
   which uses glob-style names like `*.dockerfile`, `Dockerfile`,
   `*.dockerfile`, `Containerfile`. Confirm exact pattern.
4. `sudo -n emerge --oneshot`.
5. Smoke: open a `Dockerfile`; no download.

**Verify:** `equery l dev-util/docker-langserver`;
`lsp.dockerfile.command` in config.

**Commit:** `dev-util/docker-langserver: add ebuild + opencode.jsonc wiring`

---

## Task 2.0 — Tier 2 batch (prisma)

**Goal:** Close out the remaining low-priority missing LSP
(prisma-language-server) so the verify gate can claim zero
auto-download triggers across all our file extensions.

**Files:**
- `/var/db/repos/haven-overlay/dev-util/prisma-language-server/` (new)
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Mirror Tasks 1.6/1.7 pattern (npm package).
2. Add `lsp.prisma.command = ["node", "/usr/lib64/node_modules/@prisma/language-server/dist/bin.js"]`
   to opencode.jsonc (override key matches built-in id `prisma`).
3. `sudo -n emerge --oneshot`.

**Verify:** `equery l dev-util/prisma-language-server`;
`lsp.prisma.command` in config.

**Commit:** `dev-util/prisma-language-server: add ebuild + opencode.jsonc wiring`

---

## Task 3.0 — opencode.jsonc: disable linter LSPs (eslint/oxlint/biome)

**Goal:** Stop even attempting to load the linter LSPs on TS/JS
files. They are redundant with `formatter: false` and the project's
own configured linter.

**Files:**
- `/storage/home/haven/.config/opencode/opencode.jsonc` (modified)

**Steps:**
1. Add per-id `disabled: true` entries (NOT `lsp.disable = [...]`,
   which is not a valid field per `packages/core/src/config/lsp.ts`):
   ```json
   "eslint": { "disabled": true },
   "oxlint": { "disabled": true },
   "biome": { "disabled": true }
   ```
2. Smoke: open a `.ts` file; confirm no `eslint`/`oxlint`/`biome`
   download attempt.

**Verify:** `grep -nE '"(eslint|oxlint|biome)".*"disabled": true' opencode.jsonc`
returns three new lines.

**Commit:** `opencode.jsonc: disable built-in linter LSPs (formatter:false redundant)`

---

## Task 3.1 — `.env`: enable OPENCODE_DISABLE_LSP_DOWNLOAD=1

**Goal:** Hard gate the auto-download path. Even if a future opencode
release adds a new built-in LSP we don't know about, this flag
prevents silent binary fetching.

**Files:**
- `/storage/home/haven/.config/opencode/.env` (modified)

**Steps:**
1. Add `OPENCODE_DISABLE_LSP_DOWNLOAD=1` to `.env`.
2. **Do NOT set** `OPENCODE_EXPERIMENTAL_LSP_TY=1` — this flag
   switches the Python LSP from `pyright` to `ty` (built-in
   logic in `packages/opencode/src/lsp/lsp.ts:filterExperimentalServers`),
   which would BREAK our `pyright` config. The flag we want is
   `OPENCODE_EXPERIMENTAL_LSP_TOOL` (enables the `lsp` agent tool),
   which is independent.
3. Smoke: open a `.tf`/`.rb`/`.php`/`.zig`/`.cs`/`.vue`/`.astro`/
   `.nix`/`.lua`/`Dockerfile` file; confirm either (a) LSP features
   work via portage binary, or (b) a benign "LSP not available"
   message is shown.

**Verify:** `grep -n OPENCODE_DISABLE_LSP_DOWNLOAD /storage/home/haven/.config/opencode/.env`
returns the new line; no entry in `~/.cache/opencode/` after the
smoke test.

**Commit:** `env: enable OPENCODE_DISABLE_LSP_DOWNLOAD=1 (post-portage)`

---

## Task 5.0 — AGENTS.md: document the lsp.* pattern

**Goal:** Future agents (or operator) creating new LSPs know the
pattern. Single paragraph in the overlay's AGENTS.md.

**Files:**
- `/var/db/repos/haven-overlay/AGENTS.md` (modified — add a new
  section after the existing OpenSpec/ebuild examples)

**Steps:**
1. Add a "LSP server portage convention" section explaining the
   pattern: ebuild in `dev-util/<lsp>`, explicit `lsp.<id>.command`
   override keyed by the BUILT-IN id (NOT the package name),
   `command: String[]` array, `lsp.<id>: { disabled: true }` to
   suppress, never rely on opencode's auto-download.
2. Cross-reference this change.

**Verify:** `grep -nE 'LSP.*portage convention|lsp\.<id>\.command' AGENTS.md`
returns the new section.

**Commit:** `AGENTS.md: document lsp.* opencode.jsonc pattern`

---

## Rollback strategy

If any Tier-1 task fails to land cleanly:

1. The ebuild commit can be reverted with `git revert <commit>`;
   `emerge --unmerge dev-util/<lsp>` cleans the host.
2. The opencode.jsonc patch reverts with `git checkout
   opencode.jsonc`; restart opencode.
3. `.env` change reverts with the same pattern.
4. Tier-1 tasks are independent; failure of one does not block the
   others. Promote Tier-2 batch (Task 2.0) only after all Tier-1
   tasks succeed, so a partial roll-forward still closes most of
   the gap.
5. **Task 0.1 (rename `rust-analyzer` → `rust`) is independent of
   portage and should land first**, even if all Tier-1 ebuilds
   are deferred — it closes a silent double-download that exists
   today.