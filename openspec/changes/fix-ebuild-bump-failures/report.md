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