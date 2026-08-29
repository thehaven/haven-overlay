## Task 1.1 — Regression test: SRC_URI fetchability pytest

**Goal:** A pytest that parses every ebuild in the overlay, extracts SRC_URI
distfile URLs, and HEAD-checks each — failing on 404. RED: opencode's
`opencode-models-1.16.2.json` 404s.
**Files:** `scripts/tests/test_src_uri_fetchable.py` (new)
**Steps:**
1. Write `test_src_uri_fetchable.py`: glob `**/*.ebuild`, parse `SRC_URI`
   lines (handle multi-line, `->` renames, `? ( )` conditionals by taking
   URLs only), dedupe, `urllib.request` HEAD each URL with 15s timeout,
   assert status < 400.
2. Run it — expect failure on `opencode-models-1.16.2.json` (RED evidence).
**Verify:** `pytest scripts/tests/test_src_uri_fetchable.py -x` fails with the
opencode-models 404 listed
**Commit:** `test(scripts): add SRC_URI fetchability regression test`

---

## Task 1.2 — Confirm RED

**Goal:** RED evidence captured (test output showing the 404).
**Files:** none
**Steps:**
1. Run the test, save output to the change dir as evidence.
**Verify:** test output contains `opencode-models-1.16.2.json` 404
**Commit:** (no commit — evidence only)

---

## Task 1.3 — Fix opencode ebuild

**Goal:** `dev-util/opencode/opencode-1.16.2.ebuild` no longer references the
mirror models JSON; build fetches `models.dev/api.json` at compile time.
**Files:** `dev-util/opencode/opencode-1.16.2.ebuild`, `dev-util/opencode/Manifest`
**Steps:**
1. Remove the `https://artifactory.thehavennet.org.uk/.../opencode-models-${PV}.json`
   line from SRC_URI.
2. Remove `MODELS_DEV_API_JSON="${DISTDIR}/opencode-models-${PV}.json"` from
   src_compile (keep `OPENCODE_VERSION`/`OPENCODE_CHANNEL`).
3. Regenerate Manifest (`ebuild opencode-1.16.2.ebuild manifest`).
**Verify:** `pytest scripts/tests/test_src_uri_fetchable.py` passes (GREEN);
`ebuild dev-util/opencode/opencode-1.16.2.ebuild manifest` succeeds
**Commit:** `dev-util/opencode: drop dead gentoo-mirror models JSON from SRC_URI`

---

## Task 1.4 — Confirm GREEN

**Goal:** Regression test passes.
**Files:** none
**Steps:**
1. Run the test; capture passing output.
**Verify:** exit 0, no 404s
**Commit:** (no commit)

---

## Task 1.5 — Bump opencode to 1.18.25

**Goal:** `dev-util/opencode-1.18.25.ebuild` in tree with valid Manifest.
**Files:** `dev-util/opencode/opencode-1.18.25.ebuild` (new), `dev-util/opencode/Manifest`
**Steps:**
1. Copy 1.16.2 ebuild to 1.18.25, update PV references.
2. `ebuild opencode-1.18.25.ebuild manifest` (fetches GitHub tarball only).
3. Run the regression test again.
**Verify:** `ls dev-util/opencode/` shows 1.18.25; manifest succeeds;
`pytest scripts/tests/test_src_uri_fetchable.py` green
**Commit:** `dev-util/opencode: bump to 1.18.25`

---

## Task 1.6 — Build + smoke opencode

**Goal:** `opencode --version` reports 1.18.25 from a clean install.
**Files:** none
**Steps:**
1. `sudo emerge -1 dev-util/opencode` (network-sandbox opens network for
   the models.dev fetch).
2. `opencode --version`.
**Verify:** version output = 1.18.25
**Commit:** (no commit)

---

## Task 2.1 — minions → inherit bun

**Goal:** `dev-util/minions` builds from source; no `MY_NODE_D` tarball.
**Files:** `dev-util/minions/minions-0.1.15.ebuild`, `dev-util/minions/Manifest`
**Steps:**
1. Replace `MY_NODE_D`/mirror SRC_URI with upstream source tarball;
   `inherit bun`; `RESTRICT="network-sandbox test strip"`; drop the
   node_modules fetch.
2. Regenerate Manifest; run regression test.
3. `sudo emerge -1 dev-util/minions`; smoke the binary.
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-util/minions: migrate to inherit bun (drop mirror tarball)`

---

## Task 2.2 — oh-my-openagent → inherit bun

**Goal:** source-based build, no mirror tarball.
**Files:** `dev-util/oh-my-openagent/oh-my-openagent-4.4.0.ebuild`, Manifest
**Steps:** same pattern as 2.1 (upstream source tarball, inherit bun,
RESTRICT="network-sandbox test strip", manifest, emerge, smoke)
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-util/oh-my-openagent: migrate to inherit bun (drop mirror tarball)`

---

## Task 2.3 — oh-my-opencode-slim → inherit bun

**Goal:** source-based build, no mirror tarball.
**Files:** `dev-util/oh-my-opencode-slim/oh-my-opencode-slim-2.0.0.ebuild`, Manifest
**Steps:** same pattern as 2.1
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-util/oh-my-opencode-slim: migrate to inherit bun (drop mirror tarball)`

---

## Task 2.4 — opencode-plugin-morph-fast-apply → inherit bun

**Goal:** source-based build, no mirror tarball.
**Files:** `dev-util/opencode-plugin-morph-fast-apply/opencode-plugin-morph-fast-apply-1.9.0.ebuild`, Manifest
**Steps:** same pattern as 2.1
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-util/opencode-plugin-morph-fast-apply: migrate to inherit bun`

---

## Task 2.5 — opencode-plugin-otel → inherit bun

**Goal:** source-based build, no mirror tarball.
**Files:** `dev-util/opencode-plugin-otel/opencode-plugin-otel-1.0.0.ebuild`, Manifest
**Steps:** same pattern as 2.1
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-util/opencode-plugin-otel: migrate to inherit bun`

---

## Task 2.6 — opencode-plugin-tmux → inherit bun

**Goal:** source-based build, no mirror tarball.
**Files:** `dev-util/opencode-plugin-tmux/opencode-plugin-tmux-1.5.7.ebuild`, Manifest
**Steps:** same pattern as 2.1
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-util/opencode-plugin-tmux: migrate to inherit bun`

---

## Task 2.7 — semantic-release → inherit npm

**Goal:** source-based build via npm eclass, no mirror tarball.
**Files:** `dev-util/semantic-release/semantic-release-25.0.3.ebuild`, Manifest
**Steps:** same pattern as 2.1 but `inherit npm` (pure-registry package;
`NPM_AUTO_BIN=1` or `npm_install_bin`)
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-util/semantic-release: migrate to inherit npm`

---

## Task 2.8 — tokscale → inherit bun

**Goal:** source-based build, no mirror tarball.
**Files:** `dev-util/tokscale/tokscale-2.1.3.ebuild`, Manifest
**Steps:** same pattern as 2.1
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-util/tokscale: migrate to inherit bun`

---

## Task 2.9 — audiobookshelf → inherit bun

**Goal:** source-based build; drop client+server node_modules tarballs.
**Files:** `www-apps/audiobookshelf/audiobookshelf-2.35.1.ebuild`, Manifest
**Steps:** same pattern as 2.1 (both tarballs removed; upstream source +
`bun install --frozen-lockfile --ignore-scripts`; note BUN_SKIP_COMPILE if
still needed)
**Verify:** emerge succeeds; regression test green
**Commit:** `www-apps/audiobookshelf: migrate to inherit bun (drop mirror tarballs)`

---

## Task 2.10 — Smoke all converted packages

**Goal:** every converted package installs and its binary runs.
**Files:** none
**Steps:**
1. For each of 2.1–2.9: `sudo emerge -1 <pkg>`; run `--version`/`--help`.
**Verify:** all binaries respond
**Commit:** (no commit)

---

## Task 3.1 — yq URL fix + bump

**Goal:** `dev-go/yq` at 4.53.6 with `v`-prefixed archive URL.
**Files:** `dev-go/yq/yq-3.4.1.ebuild` → `yq-4.53.6.ebuild`, Manifest
**Steps:**
1. SRC_URI → `https://github.com/mikefarah/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz`.
2. Bump to 4.53.6; regenerate Manifest; regression test.
3. `sudo emerge -1 dev-go/yq`; `yq --version`.
**Verify:** version = 4.53.6; regression test green
**Commit:** `dev-go/yq: fix v-prefixed SRC_URI, bump to 4.53.6`

---

## Task 3.2 — openclaw MY_PV fix

**Goal:** `app-misc/openclaw` fetches `openclaw-2026.7.1-2.tgz` (dash, not `_p2`).
**Files:** `app-misc/openclaw/openclaw-2026.7.1.ebuild`, Manifest
**Steps:**
1. Add `MY_PV="2026.7.1-2"` (or derive from upstream version), SRC_URI uses
   `${MY_PV}`; keep PMS PV as-is.
2. Regenerate Manifest; regression test; emerge + smoke.
**Verify:** manifest succeeds; regression test green
**Commit:** `app-misc/openclaw: fix npm tarball version normalization (MY_PV)`

---

## Task 3.3 — inquirer upstream fix

**Goal:** `dev-python/inquirer` points at the real inquirer PyPI package.
**Files:** `dev-python/inquirer/inquirer-0.2.4.ebuild`, Manifest, metadata.xml
**Steps:**
1. SRC_URI → `https://files.pythonhosted.org/...` for `inquirer` (or rename
   package to InquirerPy if that is the intended upstream — verify HOMEPAGE).
2. Regenerate Manifest; regression test; emerge + smoke.
**Verify:** manifest succeeds; regression test green
**Commit:** `dev-python/inquirer: point SRC_URI at correct upstream`

---

## Task 3.4 — mcp-* discovery source fix

**Goal:** discover hooks for the 6 mcp-* packages use the npm registry, not
GitHub tags.
**Files:** `metadata/discover-hooks/dev-util/mcp-postgres`,
`metadata/discover-hooks/dev-util/mcp-server-brave-search`,
`metadata/discover-hooks/dev-util/mcp-server-github`,
`metadata/discover-hooks/dev-util/mcp-server-memory`,
`metadata/discover-hooks/dev-util/mcp-server-sequential-thinking`,
`metadata/discover-hooks/dev-util/mcp-server-karakeep`
**Steps:**
1. Change each hook to `source = "npm"` (or the ebuild-updater npm source
   form) with the correct scoped package name.
2. Run `ebuild-updater status` (or nvchecker) to confirm discovered versions
   now match npm (`0.6.2`, `2026.7.4`, `2025.4.8`, `0.32.0`).
**Verify:** `newver.json` shows npm versions, not `2026.8.18`
**Commit:** `metadata: fix mcp-* discover hooks to npm registry source`

---

## Task 3.5 — pyright discover hook fix

**Goal:** pyright discovery no longer picks date tags.
**Files:** `metadata/discover-hooks/dev-python/pyright`
**Steps:**
1. Replace `use_max_tag = true` with a semver-aware source (regex on
   `releases/tag/v([\d\.]+)` or `use_max_tag` with a version filter).
2. Confirm discovery resolves to 1.1.x.
**Verify:** `newver.json` shows 1.1.x
**Commit:** `metadata: fix pyright discover hook (date tags vs semver)`

---

## Task 3.6 — Smoke URL-fix packages

**Goal:** yq, openclaw, inquirer build and run.
**Files:** none
**Steps:** emerge each; run `--version`/`--help`
**Verify:** all respond
**Commit:** (no commit)

---

## Task 4.1 — PyPI hash-path bump hooks

**Goal:** bump stage regenerates correct PyPI hash paths for 7 packages.
**Files:** `metadata/bump-hooks/dev-python/onnxruntime`,
`metadata/bump-hooks/dev-python/onnxruntime-gpu`,
`metadata/bump-hooks/dev-python/torchcodec`,
`metadata/bump-hooks/dev-python/nvidia-cublas-cu12`,
`metadata/bump-hooks/dev-python/nvidia-cudnn-cu12`,
`metadata/bump-hooks/dev-python/grafana-dashboard-manager`,
`metadata/bump-hooks/dev-python/pyannote-audio`
**Steps:**
1. For each: write a hook that queries `pypi.org/pypi/<pkg>/<ver>/json`,
   resolves the wheel/sdist URL, prints `SRC_URI_HASH_PATH=<path>` (or the
   KEY=VALUE form bump.py consumes).
2. Test each hook with the failing version (e.g. onnxruntime 1.29.0).
**Verify:** each hook prints a 200-resolving URL for the failing version
**Commit:** `metadata: add PyPI hash-path bump hooks (7 packages)`

---

## Task 4.2 — GitHub asset-name fixes

**Goal:** SRC_URI asset names match real release assets for 9 packages.
**Files:** `sys-apps/pnpm-bin/pnpm-bin-10.34.4.ebuild`,
`net-nntp/nzbhydra2/nzbhydra2-4.7.6.ebuild`, `dev-ml/tabby/tabby-0.32.0.ebuild`,
`dev-util/tinymist/tinymist-0.15.2.ebuild`, `net-nntp/readarr/readarr-0.4.18.2805.ebuild`,
`app-editors/obsidian-bin/obsidian-bin-1.13.7.ebuild`,
`media-tv/jellyfin-bin/jellyfin-bin-10.6.2.ebuild`,
`dev-ml/chromadb-bin/chromadb-bin-1.4.2.ebuild`, `dev-ml/vllm/vllm-0.19.0.ebuild`
(+ Manifests)
**Steps:**
1. Per package: correct the asset name to the verified real one
   (pnpm-linux-x64.tar.gz, nzbhydra2-*-generic.zip, tabby_x86_64-manylinux_2_28.tar.gz,
   tinymist -rc assets, Readarr.develop.*, obsidian ≤1.13.6, jellyfin
   alternative source, chromadb alternative source, vllm 0.28.0).
2. Regenerate Manifests; regression test; emerge + smoke each.
**Verify:** manifests succeed; regression test green
**Commit:** `dev-ml/net-nntp/sys-apps: fix GitHub release asset names (9 packages)`

---

## Task 4.3 — torch USE=cuda wheel source

**Goal:** torch USE=cuda fetches from download.pytorch.org/whl/cu126/.
**Files:** `dev-python/torch/torch-2.10.0.ebuild`, Manifest
**Steps:**
1. Change the cuda SRC_URI to
   `https://download.pytorch.org/whl/cu126/torch-${PV}%2Bcu126-cp312-cp312-manylinux_2_28_x86_64.whl -> ${P}+cu126-cp312.whl.zip`.
2. Regenerate Manifest; regression test; `USE=cuda emerge -1 dev-python/torch`.
**Verify:** manifest succeeds with USE=cuda; regression test green
**Commit:** `dev-python/torch: fetch cu126 wheel from download.pytorch.org`

---

## Task 4.4 — Smoke asset-fix packages

**Goal:** affected packages build and run.
**Files:** none
**Steps:** emerge each; smoke binaries
**Verify:** all respond
**Commit:** (no commit)

---

## Task 5.1 — nats-server source-based migration

**Goal:** `dev-db/nats-server` builds from source; no vendor tarball.
**Files:** `dev-db/nats-server/nats-server-2.10.22.ebuild`, Manifest
**Steps:**
1. Drop the `dev.gentoo.org/~haven` vendor tarball; use go-module with
   `RESTRICT="network-sandbox"` (go mod download at build time) or vendor
   via `go mod vendor` in-tree.
2. Regenerate Manifest; regression test; emerge + smoke (`nats-server --version`).
**Verify:** emerge succeeds; regression test green
**Commit:** `dev-db/nats-server: migrate to source-based build (drop vendor tarball)`

---

## Task 5.2 — mattermost-server source-based migration

**Goal:** `net-im/mattermost-server` builds from source; no vendor tarball.
**Files:** `net-im/mattermost-server/mattermost-server-11.6.1.ebuild`, Manifest
**Steps:** same pattern as 5.1 (keep the releases.mattermost.com webapp tarball
if still required)
**Verify:** emerge succeeds; regression test green
**Commit:** `net-im/mattermost-server: migrate to source-based build (drop vendor tarball)`

---

## Task 5.3 — chezmoi source-based migration

**Goal:** `app-misc/chezmoi` builds from source; no `-deps.tar.xz`.
**Files:** `app-misc/chezmoi/chezmoi-2.70.0.ebuild`, Manifest
**Steps:** same pattern as 5.1 (go-module, network-sandbox)
**Verify:** emerge succeeds; regression test green
**Commit:** `app-misc/chezmoi: migrate to source-based build (drop deps tarball)`

---

## Task 5.4 — Smoke migrated packages

**Goal:** nats-server, mattermost-server, chezmoi build and run.
**Files:** none
**Steps:** emerge each; `--version` smoke
**Verify:** all respond
**Commit:** (no commit)

---

## Task 6.1 — Full pytest suite

**Goal:** no other tests broken.
**Files:** none
**Steps:** `pytest /var/db/repos/haven-overlay/scripts/tests/`
**Verify:** all pass (or only pre-existing failures documented)
**Commit:** (no commit)

---

## Task 6.2 — ebuild-updater status re-check

**Goal:** fixed packages absent from failures.
**Files:** none
**Steps:** `ebuild-updater status` (or inspect pipeline_state.json after a run)
**Verify:** opencode, yq, openclaw, mcp-*, converted packages no longer in
packages_failed
**Commit:** (no commit)

---

## Task 6.3 — Regression on previously-OK packages

**Goal:** the 22 packages that bump OK are unaffected.
**Files:** none
**Steps:** compare `packages_completed` before/after; spot-check 3 packages
**Verify:** no new failures
**Commit:** (no commit)