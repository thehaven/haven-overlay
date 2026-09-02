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

### ⛔ Duplicate pre-flight (before adding ANY new package)

Search THIS overlay first — not just ::gentoo or Zugaina. `eix` is stale on
this host and third-party indexes miss committed packages. A same-upstream
package added twice in different categories diverges and collides on file
paths (prime-agent was packaged in both `app-misc/` and `dev-util/` on
2026-08-08 because neither author checked).

```bash
# 1. Same-name package directories anywhere in this overlay
ls -d /var/db/repos/haven-overlay/*/<name> 2>/dev/null
# 2. Upstream identity across every ebuild in this overlay
grep -rl "<owner>/<repo>" /var/db/repos/haven-overlay --include="*.ebuild"
# 3. Hooks/config referencing the package
grep -rl "<name>" /var/db/repos/haven-overlay/metadata 2>/dev/null
```

If an ebuild for the same upstream exists (any category/version), extend or
bump it; never add a second one.

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

**Conversion status (2026-08-12):** `bash-language-server` and
`yaml-language-server` converted to the `npm install --global` pattern
(pure-registry, prebuilt output); `crewbee` converted to `inherit bun`
with the npm-lockfile drop (`rm -f package-lock.json; bun install
--ignore-scripts; bun run build`); `opencode-plugin-safety-net`
converted to `inherit bun` with a native `bun.lock` (`bun install
--frozen-lockfile --ignore-scripts; bun run build`; deps installed
under the module root so `shell-quote` resolves at runtime). Remaining
holds (bun-source-built or monorepo CLIs, convert on next touch):
`opencode-plugin-canvas`, `opencode-plugin-otel`, `opencode-plugin-tmux`,
`opencode-plugin-morph-fast-apply`, `composio-mcp`, `semantic-release`,
`minions`, `tokscale`, `oh-my-openagent`, `oh-my-opencode-slim`,
`hermes-workspace`, `www-apps/audiobookshelf`, and
`www-apps/readmeabook` (ships `${PN}-node_modules-${PV}` + fonts vendor
tarballs from artifactory.delivery.haven.pw with `BUN_SKIP_COMPILE=1`;
offline-correct, so no `RESTRICT="network-sandbox"` needed).

Do not add new pre-bundled node_modules tarballs. Do not define new
`MY_NODE_D`. Do not introduce `vendor/` symlinks.

### Node CLI / agent monorepo template (determinism contract)

For npm-workspaces monorepo CLIs (bundled `dist/` that still imports external
runtime packages like zeromq/chalk), this is the canonical build so any two
packagings converge:

1. Build from the repo tag tarball with the repo's OWN lockfile:
   `npm ci --ignore-scripts --no-audit --no-fund` (or `bun install
   --frozen-lockfile --ignore-scripts` ONLY if the project is bun-native;
   bun 1.3.x cannot migrate npm lockfiles and its stash layout breaks tsgo on
   non-hoisted transitive deps — verified on prime-agent).
2. `npm run build`, then reinstall production-only:
   `rm -rf node_modules && npm ci --omit=dev --ignore-scripts --no-audit --no-fund`.
3. Install `dist/` + `package.json` + `node_modules/` together; keep workspace
   symlinks valid by installing the referenced `packages/*` alongside.
4. Prune foreign-platform native addons (koffi/zeromq etc. ship all OS/arch
   builds); keep linux-x64 glibc only. Declare `QA_PREBUILT="*"`.
5. LICENSE lists the bundled dependency licenses, not just upstream's.
6. Bin: direct symlink `dosym ... /usr/bin/<name>` + `fperms +x` on the target.
7. `RESTRICT="network-sandbox"` (OPENS network — `npm ci` fetches the registry)
   with an explanatory comment; `RESTRICT+=" test"` when tests are skipped.

## Python ebuild conventions

The `gentoo-ebuild` skill is authoritative on `PYTHON_COMPAT`. The
overlay-specific constraint worth carrying forward: cap at
`python3_{12..14}`. Adding `python3_15` is rejected by the frozen
`/usr/portage/eclass/python-utils-r1.eclass` on the webhost with
"Invalid implementation in PYTHON_COMPAT: python3_15", regardless of
the build host's actual Python versions. Check the eclass's
`_python_set_impls` if in doubt.

## Verified gotchas (overlay-specific)

- **`artifactory.thehavennet.org.uk/artifactory/gentoo-mirror` only mirrors
  the three official Gentoo distfile sources** (`distfiles.gentoo.org`,
  `mirror.bytemark.co.uk/gentoo`, `mirrorservice.org/sites/distfiles.gentoo.org`).
  If a file does not live in one of those upstream repositories it will NOT
  be made available there — it is for official Gentoo ebuilds, not
  third-party artefacts. Do NOT rely on it for custom vendor tarballs
  (`*-node_modules-*.tar.xz`, models JSON, `*-deps.tar.xz`): they 404
  (verified 2026-08-29 — cache cleaned, gone permanently). The failure mode
  is silent: `ebuild manifest` aborts on the missing file and
  `ebuild-updater`'s bump stage rolls back, so the package stops updating
  with no operator-visible error. Use source-based builds
  (`inherit bun`/`npm` + `RESTRICT="network-sandbox"`), upstream release
  assets, or operator-hosted files on `dev.gentoo.org/~haven` (uploaded per
  version before the bump runs).

- **`masked by: corruption` is secondary.** It appears when portage fails
  to load an ebuild and falls back to other versions; the local metadata
  cache is stale. Fix the primary ebuild error first, then
  `emaint sync -r haven-overlay` and
  `rm -rf /var/cache/edb/dep/*/haven-overlay` to clear the cache.
- **[`dev-util/mcp-meta`](dev-util/mcp-meta/) is the virtual.** Individual MCP servers
  ([`dev-util/opencode-plugin-snippets`](dev-util/opencode-plugin-snippets/), [`dev-util/chrome-devtools-mcp`](dev-util/chrome-devtools-mcp/), etc.) are
  pulled in as USE-flag-gated deps via `profiles/use.local.desc`.
  [`scripts/verify-mcp.sh`](scripts/verify-mcp.sh) is the smoke-test runner for the binary list
  it documents at the top.

- **`\$` in ebuild variable assignments is a literal, not a variable.** An
  ebuild with `S="\${WORKDIR}/\${MY_P}"` (backslash before `$`) assigns the
  literal string and dies in the prepare phase with "The source directory
  '${WORKDIR}/${MY_P}' doesn't exist". This hit both `dev-python/aisuite`
  ebuilds (fixed 2026-08-08); grep for `\$` in `S=` / `SRC_URI=` when an
  ebuild fails with a literal-variable path.


- **`dev-python/omegaconf` pins `antlr4-python3-runtime` 4.9.3 — never bump
  antlr4 independently.** omegaconf 2.3.1 (latest stable) ships an ATN-v3
  grammar; antlr4 runtimes >=4.13 (ATN v4) refuse to deserialize it, so every
  `import omegaconf` dies with "Could not deserialize ATN with version 3
  (expected 4)". Because hydra-core registers a pytest11 plugin, the whole
  pytest suite then fails at collection with an unrelated-looking traceback.
  ::gentoo only ships 4.13.2, so the 4.9.3 ebuild lives in this overlay
  (`dev-python/antlr4-python3-runtime/`). Diagnostic:
  `grep SERIALIZED_VERSION /usr/lib/python3.14/site-packages/antlr4/atn/ATNDeserializer.py`
  (3 = compatible, 4 = broken for omegaconf). Hit 2026-08-22; fixed by
  pinning `=dev-python/antlr4-python3-runtime-4.9.3*` in omegaconf's RDEPEND.

- **`metadata/md5-cache/` is not maintained per-commit.** Recent commits
  (bumps, prunes) do not touch it; the webhost regenerates it in bulk
  (`emaint sync -r haven-overlay` + `egencache --repo=haven-overlay --update`).
  If you run egencache locally it rewrites hundreds of stale entries — revert
  with `git checkout -- metadata/md5-cache/` and delete untracked entries
  before committing.

- **Untracked files in this overlay are not safe.** Automated overnight
  processes (retention prunes etc.) remove untracked files — the
  `dev-util/agent-skill-finder` ebuild was lost this way on 2026-08-22.
  Commit approved work promptly; never leave a finished ebuild uncommitted
  overnight.

- **metadata.xml maintainer email: copy from
  `dev-util/opencode-snip/metadata.xml`.** Several older files
  (`dev-python/omegaconf`, `dev-python/hydra-core`) carry a
  `haven@example.com` placeholder; the real address is
  `haven@thehavennet.org.uk`. When creating metadata.xml, copy an existing
  file and change the remote-id rather than typing the email.

- **`EGIT_REPO_URI` must be a public https URL — never `file://` under the
  operator's home.** Builds run as the `portage` user (`FEATURES=userpriv`);
  `/storage/home/haven` is mode 700, so `file:///storage/home/haven/...`
  URIs pass every root-based gate (`sudo ebuild clean install`, `ebuild
  manifest` — which is a no-op for git-r3 anyway) and then die mid-batch in
  `src_unpack` with "does not appear to be a git repository" (2026-08-13:
  mcp-mesh-0.19.1, mcp-forge-9999, better-brain-9999; 34 ebuilds migrated
  back to `https://gitlab-ee.thehavennet.org.uk/...` in one commit). Same
  class: `ssh://` and scp-style URIs (portage has no credentials) and dead
  `git://` (GitHub disabled it in 2022). Run
  [`scripts/verify-git-uris.sh`](scripts/verify-git-uris.sh) after any
  change that touches `EGIT_REPO_URI` — it probes every URI as the portage
  user, the only context that matches a real build.

- **`DISTUTILS_USE_PEP517` must match upstream `pyproject.toml` `build-backend`.
  Always verify per-version — never assume sibling ebuilds share a build
  backend.** Upstream Python projects change build backends between minor
  versions (setuptools → hatchling, poetry → maturin, hatchling → uv-build,
  etc.); `ebuild-updater bump` copies the LATEST ebuild as the new-version
  template, so the stale value propagates to every future bump until
  someone notices. Symptom is a hard die in `src_compile`:
  `DISTUTILS_UPSTREAM_PEP517 does not match pyproject.toml! ... DISTUTILS_USE_PEP517 value incorrect`.
  Verified 2026-09-02 across **47 ebuilds in 11 packages** (face, stripe,
  b2sdk, copier, httpx-retries, langfuse, litellm, pagerduty,
  phx-class-registry, pyacoustid, solana). The trigger case was
  `face-26.0.1`; an audit found 46 more. Anti-pattern: a sibling fix
  assumed `face-26.0.0` shared the backend with 26.0.1 — it didn't
  (`26.0.0` is `setuptools.build_meta`, `26.0.1` is `flit_core.buildapi`).
  Same class on `phx-class-registry`: 5.1.1 uses poetry, 5.2.1/5.2.2 use
  hatchling. **Always extract `pyproject.toml` from the specific
  tarball** and grep `build-backend`. Detection: an audit script
  (`/tmp/opencode/pep517-audit/audit.py`, to be promoted to
  `scripts/audit_pep517_backend_drift.py` per
  [`openspec/changes/add-pep517-backend-drift-scan/`](openspec/changes/add-pep517-backend-drift-scan/))
  scans every `dev-python/*/*.ebuild`, compares against the cached tarball
  in `/usr/portage-distfiles/`, and reports the canonical
  `DISTUTILS_USE_PEP517` value via the skill mapping table. `ebuild-updater
  cleanup scan` should also pick this up (openspec filed).

## Retention rename workflow

When a commit renames a package in this overlay (e.g. the
`2d581104 retention: remove 14 duplicate packages` commit that moved
`dev-util/rtk` to `app-misc/rtk`), the commit itself can only redirect
*internal* ebuild dependents. The operator's `/var/lib/portage/world`
and any installed instances of the old atom are out of the commit's reach.

**Required steps in the commit message.** Every rename-bearing commit must
spell out the operator workflow that follows it; otherwise the operator
runs the obvious-but-wrong four-step transition and ends up with the old
atom unmerged and the new one not installed. The wrong sequence:

```bash
emerge --deselect <old>            # edits world
emerge --select <new>               # edits world
emerge <new>                        # FAILS at pkg_preinst (file collision
                                    #   against the still-installed old)
emerge --unmerge <old>              # succeeds — too late, <new> never installed
```

Net effect (verified incident 2026-09-01): `/usr/bin/rtk` and
`/usr/lib64/node_modules/opencode-antigravity-auth/` were gone, neither
replacement installed, no recovery until `emerge app-misc/rtk` was run
explicitly.

### Right sequence

```bash
# 1. Unmerge the old atom first (clears /var/db/pkg/<old> and owned files)
emerge --unmerge <old>
# 2. Then --deselect / --select / emerge
emerge --deselect <old>
emerge --select <new>
emerge <new>
```

Or run the bundled helper which does all four steps in the correct order
and skips ones that no longer apply (idempotent):

```bash
sudo scripts/retention-rename.sh [--dry-run|--pretend] <old-atom> <new-atom> [<old> <new> ...]
```

`--dry-run` prints what would happen. `--pretend` invokes `emerge
--pretend` for the install step (real dep solver, no filesystem writes) but
still dry-runs unmerge/deselect/select. Use `--pretend` as the smoke test
before committing to a real run.

### Checklist for the commit message

If the commit renames atoms, the body must include:

```text
## Operator follow-up

This commit renames the following packages:
  <old-cat>/<old-pkg>  ->  <new-cat>/<new-pkg>

To complete the transition on each host that has <old-cat>/<old-pkg>
installed, run:

  sudo scripts/retention-rename.sh <old-cat>/<old-pkg> <new-cat>/<new-pkg>

Or manually:
  emerge --unmerge <old-cat>/<old-pkg>
  emerge --deselect <old-cat>/<old-pkg>
  emerge --select    <new-cat>/<new-pkg>
  emerge             <new-cat>/<new-pkg>

Hosts without <old-cat>/<old-pkg> installed (fresh installs, future
operators) need only the last `emerge <new>` step.
```

Without this block, the operator either guesses and gets the wrong order,
or doesn't notice the rename at all (until the next `emerge --pretend
@world` shows `<old-cat>/<old-pkg>: no ebuilds to satisfy`).

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

# Verify every EGIT_REPO_URI in the tree is fetchable by the portage user
# (catches file:///ssh:///git:// URIs that root-based gates cannot see)
sudo /var/db/repos/haven-overlay/scripts/verify-git-uris.sh

# Smoke test MCP binaries after a packaging change
sudo /var/db/repos/haven-overlay/scripts/verify-mcp.sh

# Apply a retention rename (old -> new atom pairs) on this host. Idempotent;
# run --dry-run first to see what would happen, --pretend to also invoke
# `emerge --pretend` for the install step without filesystem writes.
sudo /var/db/repos/haven-overlay/scripts/retention-rename.sh [--dry-run|--pretend] <old> <new> ...

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
