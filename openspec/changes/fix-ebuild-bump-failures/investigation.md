## Existing context (vault)

- `Projects/haven-overlay/findings.md` (2026-08-04): "fix newest ebuild
  first — bump engine propagates" — ebuild-updater copies the LATEST ebuild
  as the new-version template, so fixes propagate to all future bumps;
  "identical ebuild, different behaviour → tarball differs" — per-version
  behaviour lives in the upstream tarball, not the ebuild.
- `Inbox/AI-drafts/202605251000-gentoo-source-ebuilds.md` (2026-05-25):
  an early draft recommended Artifactory vendor tarballs
  (`<pkg>-node_modules-<ver>.tar.xz`) for offline builds — **superseded**:
  the gentoo-mirror cache was cleaned (2026-08-29) and the overlay policy
  (AGENTS.md) now forbids pre-bundled node_modules tarballs entirely.

## Hypothesis

The bump stage fails because `ebuild manifest` must download every
`SRC_URI` file, and a large fraction of the overlay's SRC_URI entries point
at files that deterministically do not exist: custom artefacts on a mirror
that only serves official Gentoo distfiles, vendor tarballs never uploaded
for the new version, versions that were never published upstream, and
URL-derivation bugs that produce wrong filenames.

## Evidence

All checks run 2026-08-29; every failure is deterministic (zero transient):

1. **Mirror 404s (15/15 files)** — `artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/`:
   `opencode-models-1.18.25.json` and `opencode-models-1.16.2.json` → 404;
   every `*-node_modules-*.tar.xz` (minions, oh-my-openagent,
   oh-my-opencode-slim, opencode-plugin-morph-fast-apply, opencode-plugin-otel,
   opencode-plugin-tmux, semantic-release, tokscale, audiobookshelf-client) → 404.
   Storage API confirms the repo exists (257 children) but none of these files
   are present. The mirror only aggregates the three official Gentoo distfile
   sources; custom files were cache entries and are gone permanently.
2. **`dev.gentoo.org/~haven` vendor tarballs** — `nats-server-2.14.6-vendor.tar.xz`
   AND the current `nats-server-2.10.22-vendor.tar.xz` → 404; same for
   mattermost-server (11.10.1 and current 11.6.1). Current ebuilds are broken.
3. **GitHub deps assets** — `chezmoi-2.72.0-deps.tar.xz` AND current
   `chezmoi-2.70.0-deps.tar.xz` → 404; release API shows chezmoi never
   attaches `-deps.tar.xz` assets. `dive-0.13.1-gentoo-deps.tar.xz` → 404 but
   current `dive-0.12.0-gentoo-deps.tar.xz` → 206 (per-version upload gap).
4. **npm version mismatch** — `server-*-2026.8.18.tgz` (mcp-postgres,
   mcp-server-brave-search, mcp-server-github, mcp-server-memory,
   mcp-server-sequential-thinking) → 404; real npm versions are 0.6.2 /
   2026.7.4 / 2025.4.8. `mcp-0.33.2.tgz` → 404 (`@modelcontextprotocol/mcp`
   does not exist; SDK is `@modelcontextprotocol/sdk`). Discovery uses GitHub
   tags of the monorepo, which do not match npm package versions.
5. **crates.io** — `deranged-0.4.01.crate`, `heck-0.8.0.crate`,
   `regex-automata-0.4.24.crate`, `aws-lc-sys-0.52.1.crate`,
   `ext-php-rs-clang-sys-1.15.8-extphprs.1.crate` → 403 (never published;
   API confirms max versions 0.4.1 / 0.5.0 / 0.4.18 / 0.44.0 /
   1.8.1-extphprs.{1,2}). Current ebuilds pin different versions — these
   failures are stale historical noise (bump.py has no CRATES regeneration).
6. **PyPI** — `onnxruntime-1.29.0-cp312.whl.zip`, `torchcodec-0.16.0-cp312.whl.zip`,
   `nvidia-cublas-cu12-12.9.2.10.x86_64.whl.zip`, `nvidia-cudnn-cu12-9.25.1.1.x86_64.whl.zip`,
   `pyannote_audio-4.0.7.tar.gz`, `grafana_dashboard_manager-0.2.10.92469056881.tar.gz`
   all exist on PyPI (200) — the failure is the hardcoded hash-path in SRC_URI
   (bump regenerates a stale path). `torch 2.10.0+cu126` is NOT on PyPI (lives
   on download.pytorch.org/whl/cu126/); `vllm 0.28.1rc0` never published.
7. **GitHub release assets** — obsidian v1.13.8 ships only `Obsidian-1.13.8.apk`
   (no desktop assets); jellyfin v10.11.11 has zero assets (repo.jellyfin.org
   → 410 Gone); tinymist v0.15.4 has no release object (repo is
   Myriad-Dreamin/tinymist, assets only on -rc releases); pnpm v12.0.0 assets
   are `pnpm-linux-x64.tar.gz` not `pnpm-bin-12.0.0-amd64-static`; chroma 1.5.9
   zero assets; tabby v4.3.1 no release object; nzbhydra2 assets are
   `nzbhydra2-8.9.0-generic.zip`; readarr v2.0.0.4645 no release object;
   pyright 2019.03.23 no assets (discovery `use_max_tag=true` picks date tags).
8. **URL derivation bugs** — yq: `archive/${PV}.tar.gz` missing `v` prefix
   (404 vs `refs/tags/v4.53.6.tar.gz` 200; tree stuck at 3.4.1); openclaw:
   `_p2` normalization of `2026.7.1-2` (404 vs dash version 200); inquirer:
   SRC_URI points at kazhala/InquirerPy (wrong package — inquirer 0.3.4
   belongs to InquirerPy).
9. **torch USE=cuda** — current ebuild references
   `artifactory.delivery.haven.pw/gentoo-distfiles/torch-2.10.0+cu126-cp312-*.whl`
   which is not staged on the private mirror (ebuild comment says operator
   must pre-stage; current version broken for USE=cuda).
10. **Timeouts** — oh-my-pi, emby-server, opencode-bin (historical; opencode-bin
    has since bumped to 1.18.25).

## Root Cause

`ebuild manifest` must download every `SRC_URI` file, and 45 packages'
SRC_URI entries point at files that deterministically do not exist — chiefly
custom artefacts on a mirror that only mirrors official Gentoo distfiles
(cache cleaned), vendor tarballs never uploaded for the new version, versions
never published upstream, and URL/discovery derivation bugs — so the bump
stage fails, rolls back, and the tree silently drifts.

## Blast Radius

- **45 packages** currently fail every bump run; the tree drifts silently
  (opencode 1.16.2 vs 1.18.25 upstream).
- **Current-version breakage**: nats-server, mattermost-server, chezmoi,
  torch (USE=cuda) cannot fetch even their in-tree versions — any fresh
  install/rebuild fails, not just bumps.
- **Fix propagation**: ebuild-updater copies the latest ebuild as the
  new-version template, so fixing the newest in-tree ebuild propagates to
  all future bumps (vault finding 2026-08-04).
- **Policy surface**: converting the 9 mirror-tarball packages to
  `inherit bun`/`npm` touches build behaviour, RESTRICT, and QA_PREBUILT —
  each conversion needs build verification, not just SRC_URI edits.
- **Discovery layer**: mcp-* and pyright hooks produce wrong versions;
  fixing hooks affects what ebuild-updater proposes next run.
- **Unrelated risk**: bump hooks added for PyPI hash-path packages must not
  break the 22 packages that currently bump OK.