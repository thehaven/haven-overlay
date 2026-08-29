## Symptom

ebuild-updater silently fails to bump 45 packages in haven-overlay: every
bump dies at the manifest-generation stage with "Couldn't download
<file>" / "Manifest generation timed out", the new ebuild is rolled back,
and no error reaches the operator. Example: `dev-util/opencode` is stuck at
1.16.2 while upstream released 1.18.25 (and `opencode-bin` bumped fine).

## Environment

- Overlay: `/var/db/repos/haven-overlay` (layman repo, master branch)
- ebuild-updater: v2.9.0 (`/usr/bin/ebuild-updater`), state in
  `/var/lib/ebuild-updater/haven-overlay/`
- Portage: `ebuild manifest` must download every `SRC_URI` file; bump.py
  rolls back on manifest failure (120s timeout per package)
- Mirror: `artifactory.thehavennet.org.uk/artifactory/gentoo-mirror` —
  only mirrors the three official Gentoo distfile sources
  (`distfiles.gentoo.org`, `mirror.bytemark.co.uk/gentoo`,
  `mirrorservice.org/sites/distfiles.gentoo.org`); custom artefacts were
  cache entries only and are gone (cache cleaned 2026-08-29)

## Reproduction Steps

1. Run `ebuild-updater status` (or inspect
   `/var/lib/ebuild-updater/haven-overlay/pipeline_state.json` from the
   latest run) — 57 packages recorded in `packages_failed`, all at stage
   "Manifest generation failed".
2. For `dev-util/opencode`: discovery finds 1.18.25
   (`newver.json`), bump copies the ebuild, then `ebuild manifest` tries
   to fetch `https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/opencode-models-1.18.25.json`
   → HTTP 404 (verified; `opencode-models-1.16.2.json` also 404).
3. For the mirror-tarball family (minions, oh-my-openagent,
   oh-my-opencode-slim, opencode-plugin-morph-fast-apply,
   opencode-plugin-otel, opencode-plugin-tmux, semantic-release, tokscale,
   audiobookshelf): every `*-node_modules-*.tar.xz` on the gentoo-mirror
   returns 404 (verified for all 15 mirror files).
4. For the remaining clusters (npm version mismatch, crates.io versions
   that were never published, PyPI pinned-hash paths, GitHub asset-name
   mismatches, missing `dev.gentoo.org/~haven` vendor tarballs): all 45
   URL checks return deterministic 404/403/410 — zero transient failures.
5. `bump.py` treats the manifest failure as fatal: unlinks the new ebuild,
   records the failure in `pipeline_state.json`, and the package stays at
   its old version with no operator-visible error.

## Expected vs Actual

**Expected:** every package with a newer upstream version bumps cleanly;
`ebuild manifest` succeeds for every `SRC_URI` file; failures surface to
the operator.

**Actual:** 45 packages fail deterministically every run; the tree drifts
silently (opencode 1.16.2 vs upstream 1.18.25); the root cause is a
combination of (a) reliance on a mirror that only serves official Gentoo
distfiles, (b) pre-bundled vendor tarballs that no longer exist anywhere,
(c) URL/discovery derivation bugs, and (d) missing bump hooks for
hash-pinned PyPI URLs.
## Resolution (2026-08-29)

All planned tasks completed and verified:

- **opencode 1.18.25** bumped; dead mirror models JSON dropped from SRC_URI
  (build fetches models.dev at compile time under `RESTRICT="network-sandbox"`).
- **9 mirror-tarball packages** (minions, oh-my-openagent,
  oh-my-opencode-slim, opencode-plugin-morph-fast-apply, opencode-plugin-otel,
  opencode-plugin-tmux, semantic-release, tokscale, audiobookshelf) migrated
  to `inherit bun`/`inherit npm` source-based builds.
- **URL derivation fixes**: yq (v-prefix, bumped 4.53.6), openclaw (dash
  version), inquirer (correct upstream); new packages editor/runs/xmod for
  inquirer's dep chain.
- **torch USE=cuda**: wheels now from `download.pytorch.org/whl/cu126/`;
  14 `nvidia-*-cu12` runtime packages added (13 new + cudnn 9.10.2.21) with
  PyPI hash-path bump hooks; torch RDEPEND pinned to the wheel's exact
  versions; bundled torchgen/functorch installed. Verified: `import torch`
  → 2.10.0+cu126, `cuda available: True`, matmul + cuDNN 9.10.2 on GPU.
- **Vendor-tarball migrations**: nats-server, mattermost-server, chezmoi
  (and dive) now build from source via go-module + `RESTRICT="network-sandbox"`.
  mattermost required three extra fixes: `S` (unpacks to mattermost-${PV}/),
  `src_unpack` (go.mod lives in server/), and a `replace` directive for an
  upstream import cycle in the published `server/public` module; plus a new
  `files/` dir (initd/confd/service/tmpfiles) that never existed.
- **Bump hooks**: PyPI hash-path family (onnxruntime, torchcodec,
  nvidia-*-cu12, grafana-dashboard-manager, pyannote-audio), GitHub asset
  renames (pnzbhydra2, pnpm-bin), mcp-* npm discovery, pyright tag sorting.
- **Holds/masks**: ebuild-updater.toml holds dead-asset packages;
  jellyfin-bin masked (repo.jellyfin.org 410).
- **Regression guard**: `scripts/tests/test_src_uri_fetchable.py` HEAD-checks
  every SRC_URI distfile; green after all fixes.
- **gentoo-factory**: discovery current (2.4.0 = latest tag; no phantom
  2.5.0), archive URL live, CLI smoke OK.

Remaining known failures (documented, not fixable in-tree): litellm Python
compat (pre-existing), chromadb-bin/tabby/vllm (upstream ships no release
assets), cockpit-file-sharing/cdktf-hcl2json (invalid upstream versions).
