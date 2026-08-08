# haven-overlay — agent operating guide

This is a personal Gentoo layman overlay for Simon Alman. It packages
custom ebuilds, ships a few local eclasses, and holds repo-level config
for [`ebuild-updater`](https://gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater) and per-package bump/discover hooks.

- Browse: [`https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay`](https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay).
- Mirror: [`https://github.com/thehaven/haven-overlay`](https://github.com/thehaven/haven-overlay) (read-only).
- Default branch: [`master`](https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay/-/tree/master). Commits land directly on master; no PRs.

## How to write an ebuild here

Start with [`docs/gentoo-ebuild-cheatsheet.md`](docs/gentoo-ebuild-cheatsheet.md).
It covers overlay layout, permissions, manifest generation, the `emerge`
`=`-atom quoting rule, common Portage failures, and the
`DISTUTILS_USE_PEP517` mapping — everything an agent needs to work in
this overlay without external context.

## Working rules (overlay-specific)

- **Commit-on-approval.** Only commit when the user explicitly approves.
  Conventional-commit style: `<category>/<pkg>: <verb> <object>`
  (e.g. `dev-util/spec-kit: bump to 0.12.4`,
  `retention: prune old versions (10 removed)`).

## Overlay layout — what's here

- [`profiles/repo_name`](profiles/repo_name) = `haven-overlay`. There is **no** `profiles/layout.conf`
  (this is a layman repo, not a master repo). The gentoo master lives at
  `/usr/portage` and is wired up in [`metadata/layout.conf`](metadata/layout.conf):
  `masters = gentoo`, `auto-sync = false`, `thin-manifests = true`,
  `sign-manifests = false`.
- [`profiles/categories`](profiles/categories) lists every category this overlay claims, including
  three not in stock gentoo: [`dev-nodejs`](dev-nodejs/) (npm registry packages),
  [`www-nginx`](profiles/categories), [`www-servers`](profiles/categories), plus overlay-local [`app-vuln`](app-vuln/). New categories
  must be added here before they can host packages.
- [`profiles/package.mask`](profiles/package.mask) records dead-upstream packages whose source
  tarballs are no longer reachable. Add to it rather than deleting the
  ebuild, so `ebuild-updater` stops trying to refresh them.
- [`eclass/`](eclass/) ships local eclasses only — [`bun.eclass`](eclass/bun.eclass), [`npm.eclass`](eclass/npm.eclass),
  [`go-module-offline.eclass`](eclass/go-module-offline.eclass), plus copies/extensions of upstream eclasses.
  See "Eclass choice" below.
- [`scripts/`](scripts/) holds helper scripts and pytest-based ebuild tests.
  [`scripts/tests/test_grafonnet_ebuild.py`](scripts/tests/test_grafonnet_ebuild.py), [`test_headroom_ai_ebuild.py`](scripts/tests/test_headroom_ai_ebuild.py),
  and [`test_litellm_ebuild.py`](scripts/tests/test_litellm_ebuild.py) each validate one package's ebuild against
  upstream metadata. Run with
  `pytest /var/db/repos/haven-overlay/scripts/tests/`.
- `metadata/md5-cache/`, `metadata/bump-hooks/`, `metadata/discover-hooks/`
  are `ebuild-updater` artefacts — the operator config lives at the repo
  root in [`ebuild-updater.toml`](ebuild-updater.toml) (hold policy travels with the git tree).
- [`haven-overlay.xml`](haven-overlay.xml) is the layman metadata (description, owner, source URL).
- [`net-im/synapse/update_ebuild.py`](net-im/synapse/update_ebuild.py) is an in-tree one-off regenerator for
  Synapse's CRATES block. Read it before running — it expects
  `crates_new.txt` in the cwd.

## Source-based Node.js / Bun policy (overlay override)

The `gentoo-ebuild` skill (§7, §7D) already documents the policy that
applies specifically here:

- **Strict source-based.** Never invoke `npm install` or `bun install`
  against the live registry during ebuild phases.
- **`RESTRICT="network-sandbox"` OPENS network — it never blocks it.**
  `FEATURES=network-sandbox` is on by default in current Portage, so build
  phases run with networking disabled. An ebuild that must download at
  build time (Go modules without a vendor tarball, `bun install` inside
  `bun_src_compile`) therefore **must** declare
  `RESTRICT="network-sandbox"` — per `man 5 ebuild` it "Disables the
  network namespace for specific packages", i.e. network is then allowed in
  every phase except `depend` (see `net-vpn/tailscale`, `net-misc/ntfy`,
  `dev-util/rulesync`). The "build fails if it touches the network"
  guarantee is automatic: ebuilds that **omit** the value build fully
  offline, and any network attempt dies in the default sandbox.
- For Bun-built upstream projects, use `inherit bun` (the overlay's local
  [`eclass/bun.eclass`](eclass/bun.eclass)). Its default `bun_src_compile` runs
  `bun install --frozen-lockfile --ignore-scripts` followed by
  `bun run build`.
- For pure-npm-registry packages, use `inherit npm` ([`eclass/npm.eclass`](eclass/npm.eclass)).
  Set `NPM_AUTO_BIN=1` to auto-symlink `package.json`'s `bin` field, or
  call `npm_install_bin <script_path> [alias]` from `src_install`.
- See `scripts/npm2ebuild.py --package <name>@<ver>` for the generator
  used when adding new npm packages.

### Pre-bundled node_modules tarballs are FORBIDDEN

A handful of ebuilds in the tree (e.g. `bash-language-server`,
`opencode-plugin-canvas`, `composio-mcp`, [`www-apps/audiobookshelf`](www-apps/audiobookshelf/))
still ship `MY_NODE_D="…-node_modules-…"` pre-built tarballs from a
private mirror (host redacted from this public repo). **These are technical debt, not the
standard pattern.** The migration direction (see git history: the
`dev-util/*: migrate 6 ebuilds to inherit bun` commit moved packages
*away* from prebuilt-vendor-tarball to source-based `inherit bun`) is
to convert them on touch. When editing one of these, convert it to
`inherit bun` (or `inherit npm` for a pure-registry package) before
bumping.

Do not add new pre-bundled node_modules tarballs. Do not define new
`MY_NODE_D`. Do not introduce `vendor/` symlinks.

## Python ebuild conventions

The `gentoo-ebuild` skill is authoritative on `PYTHON_COMPAT`. The
overlay-specific constraint worth carrying forward: cap at
`python3_{12..14}`. Adding `python3_15` is rejected by the frozen
`/usr/portage/eclass/python-utils-r1.eclass` on the webhost with
"Invalid implementation in PYTHON_COMPAT: python3_15", regardless of
the build host's actual Python versions. Check the eclass's
`_python_set_impls` if in doubt.

## Verified gotchas (overlay-specific)

- **`masked by: corruption` is secondary.** It appears when portage fails
  to load an ebuild and falls back to other versions; the local metadata
  cache is stale. Fix the primary ebuild error first, then
  `emaint sync -r haven-overlay` and
  `rm -rf /var/cache/edb/dep/*/haven-overlay` to clear the cache.
- **[`dev-util/mcp-meta`](dev-util/mcp-meta/) is the virtual.** Individual MCP servers
  ([`dev-util/opencode-snippets`](dev-util/opencode-snippets/), [`dev-util/chrome-devtools-mcp`](dev-util/chrome-devtools-mcp/), etc.) are
  pulled in as USE-flag-gated deps via `profiles/use.local.desc`.
  [`scripts/verify-mcp.sh`](scripts/verify-mcp.sh) is the smoke-test runner for the binary list
  it documents at the top.

## External infra this overlay depends on

- `https://gitlab-ee.thehavennet.org.uk` — overlay remote, and source
  for many internal ebuilds. Repositories **must be Public** for ebuild
  fetch to work without credentials.
- [`antigravity-cli-auto-updater-….us-central1.run.app`](https://antigravity-cli-auto-updater-974169037036.us-central1.run.app/)
  — upstream manifest source for `app-util/antigravity-cli-bin`
  (see [`metadata/bump-hooks/dev-util/antigravity-cli-bin`](metadata/bump-hooks/dev-util/antigravity-cli-bin)).

## [`ebuild-updater`](https://gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater) integration

- Config: [`ebuild-updater.toml`](ebuild-updater.toml) at the repo root. The hold list pins
  `dev-db/solr` to match `/storage/docker/solr/start.sh` — newer upstream
  versions show up in `status` but the bump stage will not rewrite them.
- Operator must invoke `ebuild-updater` from `/var/db/repos/haven-overlay`
  (or pass it via the wrapper) so `DEFAULT_CONFIG_PATHS` resolves the
  in-repo config. `/etc/ebuild-updater/config.toml` and
  `~/.config/ebuild-updater/config.toml` override it when present.
- `metadata/discover-hooks/<category>/<pkg>` files point nvchecker at
  non-GitHub upstream sources (e.g. internal GitLab projects). One file
  per package.
- `metadata/bump-hooks/<category>/<pkg>` files print `KEY=VALUE` lines
  consumed by the bump stage to rewrite SRC_URI variables per-version
  (e.g. for repos whose asset URLs are not derivable from the version
  tag). One file per package.

## Quick commands (overlay-specific, not in the skill)

```bash
# Refresh webhost metadata after a push
emaint sync -r haven-overlay

# Regenerate overlay metadata cache
sudo -n egencache --repo=haven-overlay --update

# Audit every inherit-npm ebuild for missing /usr/bin symlinks
sudo /var/db/repos/haven-overlay/scripts/verify-npm-bin.sh

# Smoke test MCP binaries after a packaging change
sudo /var/db/repos/haven-overlay/scripts/verify-mcp.sh

# Run ebuild metadata tests
pytest /var/db/repos/haven-overlay/scripts/tests/
```

## Known blockers

- **Webhost portage tree freeze.** `/usr/portage` on the webhost is not
  being rsync'd; `emerge --sync` does not update it. Defensive edits
  (capping `PYTHON_COMPAT`, etc.) are required for any ebuild that
  targets both dev and webhost.
- **Harbor** ([`app-admin/harbor`](app-admin/harbor/)). Swagger code generation is upstream
  container-only; cannot be packaged from source.

## Out of scope

Planning, design, and ADR-style decisions don't belong in this repo.
Skills and tooling live in a separate, private repository.
