# Report

## Symptom

opencode v2 silently fetches precompiled LSP binaries from GitHub
releases and npm whenever a file matches a built-in LSP id that has no
`lsp.<id>.command` configured in `opencode.jsonc`. That download path is
untracked by portage, bypasses the `ebuild-updater` bump discipline, and
forces `OPENCODE_DISABLE_LSP_DOWNLOAD=1` to be left disabled (because
turning it off would silently disable LSP features for 8 file types
present in our work area: `.rb` (105), `.lua` (41), `.php` (38),
`.zig`+`.zon` (18+1), `.cs` (15), `.vue` (13), `.astro` (11), `.nix`
(8), `.tf` (1), plus Dockerfile variants (~224), and `.rs` files
that already have a hidden built-in `rust` downloader firing in
addition to the explicitly-configured `rust-analyzer`.

## Environment

- Host: haven-overlay working copy, commit TBD (HEAD of master at
  filing time)
- Reference opencode v2 source: commit `aa481b8f5652f5576c55f914a64ed270e7daa7e0`
- Reference opencode.jsonc: `/storage/home/haven/.config/opencode/opencode.jsonc`
  (git-tracked in the opencode-config repo)
- Work-area scan root: `/storage/home/haven` (depth 6, excluding
  `node_modules/`, `.git/`, `dist/`, `vendor/`)
- LSP server source: `packages/opencode/src/lsp/server.ts` (1,983 lines,
  public GitHub `anomalyco/opencode`)
- LSP merge logic: `packages/opencode/src/lsp/lsp.ts` lines 140–199
- LSP config schema: `packages/core/src/config/lsp.ts` (Server class:
  `command: String[]`, `extensions?: String[]`, `disabled?: Boolean`,
  `env?: Record<String,String>`, `initialization?: Record<String, Unknown>`)

## Reproduction Steps

1. Open `/storage/home/haven/.config/opencode/.env`. Confirm
   `OPENCODE_DISABLE_LSP_DOWNLOAD=` is unset (current state).
2. Confirm `lsp.<id>.command` is configured for exactly 8 ids:
   `clangd`, `bash`, `typescript`, `yaml-ls`, `pyright`, `rust-analyzer`,
   `gopls`, `marksman`. **Note the mismatch:** the user-config key
   `rust-analyzer` does NOT match the built-in id `rust`. The merge
   logic in `lsp.ts:165–179` creates a NEW entry under `rust-analyzer`
   while the built-in `rust` server (with its GitHub downloader)
   remains in `servers`. Both fire on `.rs` files.
3. Launch opencode. Open any `.tf`, `.rb`, `.php`, `.lua`, `.zig`,
   `.zon`, `.cs`, `.vue`, `.astro`, `.nix`, `.prisma`, or `Dockerfile`
   file (or any of the 224 Dockerfile variants in the work area).
4. Observe: opencode logs a download attempt against `api.github.com`
   or the npm registry for the corresponding built-in server
   (`terraform-ls`, `ruby-lsp`, `phpactor`, `lua-language-server`,
   `zls`, `csharp-language-server`, `vue-language-server`,
   `astro-language-server`, `nixd`, `prisma-language-server`,
   `dockerfile-language-server`). Binary lands in
   `${XDG_CACHE_HOME:-~/.cache}/opencode/` and is not visible to
   `equery`, `qlist`, or `ebuild-updater`.
5. Open any `.ts`/`.js` file (70,000+ in work area). Observe:
   `eslint`, `oxlint`, or `biome` LSP fetches the corresponding
   npm package / GitHub release tarball.
6. Open any `.rs` file (71). Observe: BOTH the built-in `rust`
   server (auto-download) AND the user-configured `rust-analyzer`
   server (portage) are spawned. Auto-download happens silently.

## Expected vs Actual

**Expected:** Every LSP server running on the host has a portage origin,
is tracked in `/var/lib/portage/world` or `@world`, and is updated by
`ebuild-updater` alongside the rest of the overlay. Setting
`OPENCODE_DISABLE_LSP_DOWNLOAD=1` is safe and either (a) provides no
benefit because no auto-download is happening, or (b) provides a
security/control boundary that we have independently re-implemented
the missing servers for.

**Actual:** Ten file types in the work area trigger silent
auto-download. `OPENCODE_DISABLE_LSP_DOWNLOAD=1` would disable those
LSPs without warning. No portage provenance for the missing
language servers. Closing the gap requires portaging nine
language-server packages into `haven-overlay` and adding explicit
`lsp.<id>.command` entries in `opencode.jsonc` keyed by the BUILT-IN
id (not the package name) so the override REPLACES the built-in
`spawn` function rather than coexisting with it.

Additional pre-existing bug discovered during verification: the
existing `rust-analyzer` key in `opencode.jsonc` is silently
double-spawning with the built-in `rust` server on every `.rs` file.
This change resolves it as a side effect of the same pattern
verification.