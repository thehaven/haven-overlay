# Investigation

## Existing context (vault)

- `Projects/haven-overlay/findings.md` (2026-08-29,
  `fix-ebuild-bump-failures`): every new ebuild in the overlay must
  have a portage origin — same discipline that exposed this gap.
  Precedent for "no portage-less software on the host" is the
  `mcp-server-memory` cleanup (`review-mcp-server-memory-vs-mem0`,
  2026-09-04): a 14-MiB npm binary was being fetched outside portage
  and was deleted. Same defect class, broader scope.

## Hypothesis

`packages/opencode/src/lsp/server.ts` (line numbers from opencode
commit `aa481b8f5652f5576c55f914a64ed270e7daa7e0`) registers 35
built-in LSP ids. Each one with a GitHub-releases fetcher is gated
by `if (flags.disableLspDownload) return` (1,983-line file, 19 such
guards). When `lsp.<id>.command` is NOT configured in
`opencode.jsonc` AND a file matching the id's extension list is
opened, opencode auto-attaches the built-in server. Without an
explicit config override, the resolver path calls the fetcher and
downloads a precompiled binary.

The override pattern is non-obvious:

- `lsp.<id>.command` must be a `String[]` (array), not a String.
  Schema: `packages/core/src/config/lsp.ts` line 11 — `command:
  Schema.String.pipe(Schema.Array)`.
- The user-config key MUST match the built-in id (`packages/opencode/src/lsp/lsp.ts`
  line 165: `const existing = servers[name]`). If the key differs
  from the built-in id, the override creates a NEW entry while the
  built-in stays — **both** fire on the configured extensions. This
  is the root cause of the hidden `.rs` double-spawn in the current
  config (`rust-analyzer` user key vs `rust` built-in).
- The override replaces only the `spawn` function. The `extensions`
  list is optional; if supplied it replaces the built-in list.
- A server is fully disabled by `lsp.<id>: { disabled: true }` (NOT
  `lsp.disable = [...]`, which is not a valid field).

Our config currently overrides 8 ids (`clangd`, `bash`,
`typescript`, `yaml-ls`, `pyright`, `rust-analyzer`, `gopls`,
`marksman`). Seven of these match their built-in ids correctly;
`rust-analyzer` does NOT match `rust`. The remaining 27 built-in
ids each represent a potential auto-download trigger.

## Evidence: opencode built-in LSP registry

Extracted from `server.ts` (built-in id → extensions → fetch
mechanism), cross-checked against `core/src/config/lsp.ts` (Server
schema) and `opencode/src/lsp/lsp.ts` (merge logic):

| Built-in id | Extensions triggered | Has built-in downloader? | Default fetch URL |
|---|---|---|---|
| `deno` | .ts .tsx .js .jsx .mjs | YES (line 152) | github.com/denoland/deno (already installed at /usr/bin/deno) |
| `typescript` | .ts .tsx .js .jsx .mjs .cjs .mts .cts | YES (line 182) | npm `typescript` + `typescript-language-server` (already configured explicitly) |
| `vue` | .vue | YES (line 370) | npm `@vue/language-server` (bin: `vue-language-server`) |
| `eslint` | .ts .tsx .js .jsx .mjs .cjs .mts .cts .vue | YES (line 404) | github.com/microsoft/vscode-eslint |
| `oxlint` | .ts .tsx .js .jsx .mjs .cjs .mts .cts .vue .astro .svelte | YES (line 493) | npm `oxlint` |
| `biome` | .ts .tsx .js .jsx .json .jsonc .vue .astro .svelte .css .graphql .gql .html | YES (line 550) | github.com/biomejs/biome |
| `gopls` | .go | YES (line 598) | (already configured explicitly) |
| `ruby-lsp` | .rb .rake .ru | YES (line 834) | github.com/Shopify/ruby-lsp (Ruby gem; ships language server as gem, not npm) |
| `ty` | .py .pyi | YES (line 974) | github.com/astral-sh/ty (auto-installed at ~/.local/bin/ty by upstream installer; **not** portage) |
| `pyright` | .py .pyi | YES (line 1077) | (already configured explicitly) |
| `elixir-ls` | .ex .exs | YES (line 1110) | github.com/elixir-lsp/elixir-ls |
| `zls` | .zig .zon | YES (line 1204) | github.com/zigtools/zls (bin: `zls-x86_64-linux.tar.xz`) |
| `csharp` | .cs .csx | YES (Roslyn, line 737) | .NET install script (OmniSharp fallback: github.com/OmniSharp/omnisharp-roslyn, bin: `omnisharp-linux-x64.tar.gz`, 48 MiB) |
| `razor` | .razor .cshtml | YES (line 755) | Roslyn install |
| `fsharp` | .fs .fsi .fsx .fsscript | YES | github.com/fsharp/fsharp-language-server |
| `sourcekit-lsp` | .swift .objc .objcpp | YES | github.com/swiftlang/sourcekit-lsp |
| `rust` | .rs | YES (line 1630) | github.com/rust-lang/rust-analyzer (built-in **also** fires alongside user `rust-analyzer` key) |
| `clangd` | .c .cpp .cc .cxx .c++ .h .hpp .hh .hxx .h++ | YES (line 1703) | (already configured explicitly) |
| `svelte` | .svelte | YES (line 1782) | npm `@sveltejs/language-server` |
| `astro` | .astro | YES (line 1875) | npm `@astrojs/language-server` (bin: **`astro-ls`**, NOT `astro-language-server`) |
| `jdtls` | .java | YES | eclipse.jdt.ls |
| `kotlin-ls` | .kt .kts | YES (line 1297) | github.com/Kotlin/kotlin-lsp |
| `yaml-ls` | .yaml .yml | YES (line 1523) | (already configured explicitly) |
| `lua-ls` | .lua | YES (line 1403) | github.com/LuaLS/lua-language-server (bin: `lua-language-server-${PV}-linux-x64.tar.gz`, 3.5 MiB) |
| `php` | .php | YES (line 1295) | github.com/phpactor/phpactor (composer-based, NOT PHAR) |
| `prisma` | .prisma | YES | npm `@prisma/language-server` (bin: `prisma-language-server`) |
| `dart` | .dart | YES | dart-lang/sdk |
| `ocaml-lsp` | .ml .mli | YES | github.com/ocaml/ocaml-lsp |
| `bash` | .sh .bash .zsh .ksh | YES (line 1369) | (already configured explicitly) |
| `terraform` | .tf .tfvars | YES (line 1604) | **HashiCorp CDN** `https://releases.hashicorp.com/terraform-ls/${PV}/terraform-ls_${PV}_linux_amd64.zip` (NOT GitHub releases; current latest 0.10.0, GitHub tag v0.39.0 is outdated) |
| `texlab` | .tex .bib | YES (line 1703) | github.com/latex-lsp/texlab |
| `dockerfile` | Dockerfile Dockerfile.* *.dockerfile Containerfile Containerfile.* | YES | github.com/rcjsuen/dockerfile-language-server (npm `dockerfile-language-server`) |
| `gleam` | .gleam | YES | github.com/gleam-lang/gleam |
| `clojure-lsp` | .clj .cljs .cljc .edn | YES | github.com/clojure-lsp/clojure-lsp |
| `nixd` | .nix | YES | github.com/nix-community/nixd (source-only; no GitHub release binaries — distributed via nixpkgs primarily; cargo-binstall possible) |
| `tinymist` | .typ .typc | YES (line 1875) | github.com/Myriad-Dreamin/tinymist |
| `haskell-language-server` | .hs .lhs | YES | github.com/haskell/haskell-language-server |
| `julials` | .jl | YES | github.com/julia-vscode/julia-language-server |

## Evidence: file census in `/storage/home/haven`

Counts produced by `find /storage/home/haven -maxdepth 6 -type f
-name "*.<ext>"` (excluding `node_modules`, `.git`, `dist`,
`vendor`). Verified 2026-10-01.

| Extension | Files | Built-in id (and override key) | Has portage? | Status |
|---|---|---|---|---|
| `.py` | 35,617 | `pyright`, `ty` | pyright: yes; ty: ~/.local/bin (out-of-tree, auto-installed by upstream) | configured: `pyright` |
| `.pyi` | 1,280 | `pyright`, `ty` | same | configured |
| `.ts` | 21,332 | `typescript`, `deno`, `eslint`, `oxlint`, `biome` | typescript: yes; deno: yes; **eslint/oxlint/biome: missing** | configured: `typescript`; linter to disable |
| `.tsx` | 649 | same | same | configured |
| `.js` | 43,212 | same | same | configured |
| `.mjs` | 2,847 | same | same | configured |
| `.cjs` | 2,704 | same | same | configured |
| `.mts` | 1,749 | same | same | configured |
| `.cts` | 2,523 | same | same | configured |
| `.vue` | 13 | `vue` | **MISSING** | (***) Tier 1 |
| `.astro` | 11 | `astro` | **MISSING** | (***) Tier 1 |
| `.svelte` | 0 | `svelte` | (irrelevant) | (skip) |
| `.go` | 2,859 | `gopls` | yes | configured |
| `.rb` | 105 | `ruby-lsp` | **MISSING** | (***) Tier 1 |
| `.rake` | (low) | `ruby-lsp` | **MISSING** | (***) Tier 1 |
| `.ru` | (low) | `ruby-lsp` | **MISSING** | (***) Tier 1 |
| `.ex` / `.exs` | 0 | `elixir-ls` | (skip) |
| `.zig` / `.zon` | 18 / 1 | `zls` | **MISSING** | (***) Tier 1 |
| `.cs` / `.csx` | 15 | `csharp` (Roslyn or OmniSharp) | **MISSING** | (***) Tier 1 |
| `.fsx` | 1 | `fsharp` | **MISSING** | (skip — single file) |
| `.swift` | 1 | `sourcekit-lsp` | **MISSING** | (skip — single file; macOS-only) |
| `.rs` | 71 | `rust` (built-in **and** user's `rust-analyzer`) | yes | configured but DOUBLE-SPAWN bug; fix in Task 0.1 |
| `.c`/`.cpp`/`.cc`/`.cxx`/`.h`/`.hpp` etc | 1,210 | `clangd` | yes | configured |
| `.java` | 1 | `jdtls` | **MISSING** | (skip — single file) |
| `.kt` / `.kts` | 0 | `kotlin-ls` | (skip) |
| `.yaml` / `.yml` | 1,760 | `yaml-ls` | yes | configured |
| `.lua` | **41** | `lua-ls` | **MISSING** | (***) **Tier 1 — re-prioritised from Tier 1 stub to full Tier 1** |
| `.php` | 38 | `php` (phpactor) | **MISSING** | (***) Tier 1 |
| `.prisma` | 6 | `prisma` | **MISSING** | (***) Tier 2 |
| `.dart` | 0 | `dart` | (skip) |
| `.ml` / `.mli` | 0 | `ocaml-lsp` | (skip) |
| `.sh`/`.bash`/`.zsh`/`.ksh` | 1,972 | `bash` | yes | configured |
| `.tf` / `.tfvars` | 1 / 0 | `terraform` | **MISSING** | (***) Tier 1 |
| `.tex` / `.bib` | 0 | `texlab` | (skip) |
| `.typ` / `.typc` | 0 | `tinymist` | (skip) |
| `.gleam` | 0 | `gleam` | (skip) |
| `.clj`/`.cljs`/`.cljc`/`.edn` | 0 | `clojure-lsp` | (skip) |
| `.nix` | 8 | `nixd` | **MISSING** | (***) Tier 1 |
| `.hs` / `.lhs` | 0 | `haskell-language-server` | (skip) |
| `.jl` | 0 | `julials` | (skip) |
| `Dockerfile` | 120 | `dockerfile` | **MISSING** | (***) **Tier 1 — re-prioritised; 224 total variants** |
| `Dockerfile.*` | 102 | `dockerfile` | **MISSING** | (***) |
| `*.dockerfile` | 2 | `dockerfile` | **MISSING** | (***) |

## Prioritisation (user-approved at session `m0035` 2026-10-01)

**Tier 1 — Portage now (user-approved, with corrections):**

1. `dev-util/terraform-ls` — Go binary. SRC_URI points at HashiCorp
   CDN (NOT GitHub releases). 1 `.tf` file today, but actively
   targeted by ops/iac skill.
2. `dev-util/ruby-lsp` — Ruby gem. Uses `ruby-ng` or `ruby-fakegem`
   eclass. RDEPEND on `dev-lang/ruby` (in tree).
3. `dev-util/zls` — prebuilt Linux/amd64 tarball from
   `https://github.com/zigtools/zls/releases`.
4. `dev-util/nixd` — Rust source build (no GitHub release binaries).
   Heavy; if `cargo` build too expensive in CI, defer to Tier 2 and
   accept `.nix` files get no LSP features.
5. `dev-util/phpactor` — Composer-based install (NOT PHAR). Uses
   `dev-php/composer` pattern.
6. `dev-util/vue-language-server` — npm `@vue/language-server`. Uses
   overlay `eclass/npm.eclass`. Override key in opencode.jsonc:
   `vue` (built-in id).
7. `dev-util/astro-language-server` — npm `@astrojs/language-server`.
   Uses overlay `eclass/npm.eclass`. Override key: `astro`. **Bin
   name is `astro-ls`, not `astro-language-server`**.
8. `dev-util/lua-language-server` — prebuilt Linux/x64 tarball from
   `https://github.com/LuaLS/lua-language-server/releases`. Override
   key: `lua-ls`. 41 `.lua` files justifies Tier 1.
9. `dev-util/docker-langserver` — npm `dockerfile-language-server`.
   Uses `eclass/npm.eclass`. Override key: `dockerfile`. 224
   Dockerfile variants justifies Tier 1 (promoted from Tier 2).
10. `dev-util/omnisharp-roslyn` — 48-MiB binary tarball. Heavy dep
    (mono runtime optional). Override key: `csharp`. If build cost
    too high, fall back to OmniSharp + mono or downgrade to Tier 2.

**Tier 2 — Defer:**

- `dev-util/prisma-language-server` — npm; 6 `.prisma` files
- `dev-util/jdtls` — 1 `.java` file
- `dev-util/kotlin-ls` — 0 `.kt`
- `dev-util/fsharp-language-server` — 1 `.fsx` file
- `dev-util/sourcekit-lsp` — 1 `.swift` file (macOS-only anyway)
- `dev-util/elixir-ls`, `dev-util/dart`, `dev-util/ocaml-lsp`,
  `dev-util/texlab`, `dev-util/tinymist`, `dev-util/clojure-lsp`,
  `dev-util/gleam`, `dev-util/haskell-language-server`,
  `dev-util/julia-lsp` — zero files in work area

**Tier 3 — Don't portage (linter LSPs, redundant with `formatter: false`):**

- `eslint`, `oxlint`, `biome` — all three fire on TS/JS/Vue/Astro.
  We have `formatter: false` and rely on the project's own
  configured linter. Portaging these is redundant; the eventual
  goal is per-id `lsp.eslint: { disabled: true }` etc. in
  opencode.jsonc so they're never even attempted.

**Tier 0 — Pre-existing bug fix (independent of portage):**

0.1. Rename user config key `rust-analyzer` → `rust` so the merge
     replaces the built-in `rust` server (and its downloader)
     rather than coexisting with it. This is a one-line edit and
     should land before any Tier 1 ebuild.

## Root cause

opencode's built-in LSP architecture defaults to a download-on-demand
pattern for any built-in id not explicitly overridden by user config.
The Haven operator has not overridden the ten built-in ids that
fire on file types in our work area, leaving a silent
un-portage-tracked binary path open. Without either (a) explicit
overrides keyed by the BUILT-IN id and pointing at
portage-installed binaries, or (b) `OPENCODE_DISABLE_LSP_DOWNLOAD=1`
accepting the loss of LSP features for those file types, we cannot
close the gap.

A second-order root cause is the `rust-analyzer` (user) vs `rust`
(built-in) id mismatch, which silently double-spawns on every
`.rs` file today.

## Blast Radius

- **Immediate:** every Ruby / Lua / PHP / Zig / C# / Vue / Astro /
  Nix / Terraform / Dockerfile file open in opencode (≥419 files
  total by census) triggers a silent GitHub/npm download. Each
  binary lands outside `/var/db/pkg`, is invisible to `equery`, is
  not covered by `@world`, and is silently re-downloaded on every
  opencode version bump or cache clear.

- **Operational:** if `ebuild-updater` ever proposes a bump for any
  newly-added package below (e.g., terraform-ls upstream releases
  0.11.0), the existing nightly pipeline (`/etc/cron.daily/ebuild-updater`)
  will pick it up the same day. Without this change, the corresponding
  in-tree LSP is the GitHub download, not the portage ebuild — a
  classic "two sources of truth" defect.

- **Security:** every binary fetched is signed only by the
  upstream's GitHub release pipeline (not by `repoman`/portage
  manifest). No multi-stage verification. For a single-operator
  overlay this is acceptable, but for any future fleet, this gap is
  a CVE-amplification surface.

- **Pre-existing `.rs` bug:** the current `rust-analyzer` user
  config key silently double-spawns with the built-in `rust`
  downloader on every `.rs` file. Tier 0.1 closes this independently
  of portage.

- **No other packages affected:** scope is limited to opencode's
  built-in LSP downloader path. No interaction with mcp-mesh,
  mcp-forge, cortex, mem0, or other tooling. Adding the
  `dev-util/<lsp>` ebuilds and the matching `lsp.<id>.command`
  entries (keyed by built-in id) in opencode.jsonc is sufficient.