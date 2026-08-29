## 1. dev-util/opencode — remove dead mirror dependency

- [x] 1.1 Write regression test: pytest that parses every ebuild SRC_URI in
      the overlay and HEAD-checks each distfile URL, failing on 404
      (RED — `opencode-models-1.16.2.json` 404s) [unit]
      [investigation: evidence 1]
- [x] 1.2 Confirm the regression test fails (RED evidence captured)
      [investigation: evidence 1]
- [x] 1.3 Fix `dev-util/opencode/opencode-1.16.2.ebuild`: remove the models
      JSON from SRC_URI, drop `MODELS_DEV_API_JSON` from src_compile (build
      fetches `models.dev/api.json` at compile time; `RESTRICT="network-sandbox"`
      opens network in build phases) [unit] [investigation: evidence 1]
- [x] 1.4 Confirm the regression test passes (GREEN)
      [investigation: evidence 1]
- [x] 1.5 Bump `dev-util/opencode` to 1.18.25 (ebuild-updater bump or manual),
      regenerate Manifest [unit] [investigation: evidence 1]
- [x] 1.6 Build + clean install smoke: `emerge dev-util/opencode`, verify
      `opencode --version` = 1.18.25 [smoke] [investigation: evidence 1]

## 2. Convert mirror-tarball packages to source-based builds

- [x] 2.1 `dev-util/minions` → `inherit bun`, drop `MY_NODE_D`, add
      `RESTRICT="network-sandbox"` [unit] [investigation: evidence 1]
- [x] 2.2 `dev-util/oh-my-openagent` → `inherit bun` [unit]
      [investigation: evidence 1]
- [x] 2.3 `dev-util/oh-my-opencode-slim` → `inherit bun` [unit]
      [investigation: evidence 1]
- [x] 2.4 `dev-util/opencode-plugin-morph-fast-apply` → `inherit bun` [unit]
      [investigation: evidence 1]
- [x] 2.5 `dev-util/opencode-plugin-otel` → `inherit bun` [unit]
      [investigation: evidence 1]
- [x] 2.6 `dev-util/opencode-plugin-tmux` → `inherit bun` [unit]
      [investigation: evidence 1]
- [x] 2.7 `dev-util/semantic-release` → `inherit npm` [unit]
      [investigation: evidence 1]
- [x] 2.8 `dev-util/tokscale` → `inherit bun` [unit] [investigation: evidence 1]
- [x] 2.9 `www-apps/audiobookshelf` → `inherit bun` (client + server
      node_modules tarballs) [unit] [investigation: evidence 1]
- [x] 2.10 Build + smoke each converted package (emerge, binary present,
      `--version` works) [smoke] [investigation: evidence 1]

## 3. Fix URL derivation and discovery bugs

- [x] 3.1 `dev-go/yq`: SRC_URI → `archive/refs/tags/v${PV}.tar.gz`, bump to
      4.53.6 [unit] [investigation: evidence 8]
- [x] 3.2 `app-misc/openclaw`: `MY_PV` for the dash version
      (`openclaw-2026.7.1-2.tgz`, not `_p2`) [unit] [investigation: evidence 8]
- [x] 3.3 `dev-python/inquirer`: point SRC_URI at the correct upstream
      (inquirer on PyPI, not kazhala/InquirerPy) [unit]
      [investigation: evidence 8]
- [x] 3.4 mcp-* discovery: switch discover hooks from GitHub tags to npm
      registry source for mcp-postgres, mcp-server-brave-search,
      mcp-server-github, mcp-server-memory, mcp-server-sequential-thinking,
      mcp-server-karakeep [unit] [investigation: evidence 4]
- [x] 3.5 `dev-python/pyright`: fix discover hook `use_max_tag=true` (date
      tags sort above semver under portage comparison) [unit]
      [investigation: evidence 7]
- [x] 3.6 Build + smoke affected packages [smoke] [investigation: evidence 8]

## 4. Bump hooks for PyPI hash-path family + GitHub asset-name fixes

- [ ] 4.1 Add bump hooks (`metadata/bump-hooks/<cat>/<pkg>`) for onnxruntime,
      onnxruntime-gpu, torchcodec, nvidia-cublas-cu12, nvidia-cudnn-cu12,
      grafana-dashboard-manager, pyannote-audio — print the per-version
      hash-path KEY=VALUE consumed by the bump stage [unit]
      [investigation: evidence 6]
- [ ] 4.2 Fix GitHub asset names: pnpm-bin (`pnpm-linux-x64.tar.gz`),
      nzbhydra2 (`-generic.zip`), tabby (`tabby_x86_64-manylinux_2_28.tar.gz`),
      tinymist (Myriad-Dreamin repo, -rc release assets), readarr
      (`Readarr.develop.*`), obsidian-bin (pin ≤1.13.6 or new asset),
      jellyfin-bin (repo.jellyfin.org 410 — investigate), chromadb-bin
      (no assets — investigate), vllm (0.28.0 final) [unit]
      [investigation: evidence 7]
- [ ] 4.3 `dev-python/torch`: switch USE=cuda wheel source to
      `download.pytorch.org/whl/cu126/` (or stage on the private mirror)
      [unit] [investigation: evidence 9]
- [ ] 4.4 Build + smoke affected packages [smoke] [investigation: evidence 7]

## 5. Migrate nats-server / mattermost-server / chezmoi away from vendor tarballs

- [ ] 5.1 `dev-db/nats-server`: migrate to source-based build (go-module
      with network-sandbox), drop `dev.gentoo.org/~haven` vendor tarball
      [unit] [investigation: evidence 2]
- [ ] 5.2 `net-im/mattermost-server`: migrate to source-based build, drop
      vendor tarball [unit] [investigation: evidence 2]
- [ ] 5.3 `app-misc/chezmoi`: migrate to source-based build (go-module),
      drop `-deps.tar.xz` [unit] [investigation: evidence 3]
- [ ] 5.4 Build + smoke each (emerge, binary present) [smoke]
      [investigation: evidence 2]

## 6. Final verification

- [ ] 6.1 Run the full pytest suite (`pytest /var/db/repos/haven-overlay/scripts/tests/`)
      — no other tests broken [unit] [investigation: blast radius]
- [ ] 6.2 Run `ebuild-updater status` — confirm the fixed packages no longer
      appear in failures [smoke] [investigation: blast radius]
- [ ] 6.3 Verify the 22 packages that currently bump OK are unaffected
      [smoke] [investigation: blast radius]
## 7. gentoo-factory ebuild-updater verification

- [ ] 7.1 Run ebuild-updater against gentoo-factory — confirm the 2.5.0 tag
      is detected and the bump succeeds (previously failed on the v9999
      archive URL) [smoke]
- [ ] 7.2 Full smoke tests: emerge gentoo-factory, run the CLI, verify
      version output [smoke]
