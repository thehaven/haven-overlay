# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="Architect-centric multi-agent swarm plugin for OpenCode"
HOMEPAGE="https://github.com/ZaxbyHub/opencode-swarm"
SRC_URI="https://github.com/ZaxbyHub/opencode-swarm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/opencode-swarm-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+sandbox"

# Source-based dependency resolution: bun pulls every production dep from
# the npm registry at build time (web-tree-sitter, bash-parser are
# externalised by the upstream build, so they MUST be in node_modules at
# runtime). network-sandbox is opt-out per overlay policy — see
# /var/db/repos/haven-overlay/AGENTS.md §"Source-based Node.js / Bun policy".
RESTRICT="network-sandbox"

# Bundler floor. The binary that actually builds is chosen by the eclass,
# not by this atom: bun.eclass defaults BUN_SLOT=1.3 and bun_setup() puts
# /usr/bin/bun-1.3 first on PATH, so the build runs bun v1.3.14. The
# unversioned atom had no bound at all, so a host whose only bun-bin was
# older than the slot binary would still satisfy BDEPEND and then fail — or
# silently fall back — at build time. The floor records the minimum that is
# known to work. Measured 2026-11-18: `emerge -pv1 dev-lang/bun-bin` and
# `emerge -pv1 '>=dev-lang/bun-bin-1.3.14'` both resolve to
# dev-lang/bun-bin-1.4.4:1.4, so adding the bound changes no resolution
# today; it only forbids going below 1.3.14.
BDEPEND="
	|| ( >=dev-lang/bun-bin-1.3.14 dev-lang/bun )
	net-libs/nodejs
"

# OpenCode loads dist/index.js (node-targeted ESM bundle) under Node >=22.13
# per upstream's engines.node. The CLI entry dist/cli/index.js is bun-targeted
# (engines.bun >=1.3.13) and must be invoked via `bun` — see pkg_postinst.
RDEPEND="
	>=net-libs/nodejs-22.13
	sandbox? ( sys-apps/bubblewrap )
"

# Upstream absorbed all earlier overlay patches:
# - v7.198.2 / v7.199.0: fast-activation
# - v7.199.1: worktree-authority, acceptance-auto-inject, authority-role-policy,
#   v2-host-agent-handoff (PR #3378)
# - v7.199.3: TUI-safe startup output (PR #3405)
# - v7.199.6 / v7.200.0: v2-idless-pairing (PR #3424, issue #3423)
# - v7.200.2: Full-Auto on OpenCode V2 (PR #3447, issue #3446)
# - v7.204.8: V2 adapter hardening & CI contract (#2910, PR #3444),
#   session persistence & loud recovery (PR #3445)
#
# Server shim is installed from the canonical unversioned shim in files/.
#
# The retention patch carries fork commit 8ec883878 (v7.204.8-2-g8ec883878,
# branch feat/retention-unknown-directories-7204), the rebase onto v7.204.8
# of upstream source commit 17f92cd56: the three-tier unclaimed-directory
# lifecycle, the symlink-swap guard on the retention-log compaction path,
# and a hardening of the containment check.
#
# That last point is easy to get wrong, so state it precisely: r1 carried
# fork 16ed06e11, which already had an `isContainedInSwarmRoot()` doing a
# `startsWith(resolvedSwarmRoot + path.sep)` prefix test. 8ec883878 replaces
# the body — not the name — with a `path.relative()` check. So the patch
# hardens an existing function; it does not add one.
#
# Consequence for verification: a `grep isContainedInSwarmRoot` passes on
# both the r1 and the r2/r3 bundles and cannot tell them apart. The
# src_install greps below are presence-only. The discriminator is the
# sha256 gate at the top of src_compile, which pins the three patched
# retention sources to their 8ec883878 content: a bundle built from an
# r1-era patch fails there, before any bundle is produced. Do not add a
# `grep 'path.relative('` to src_install — it asserts an implementation
# detail that any refactor may legitimately change.
#
# ${P} has no ebuild revision by definition (man 5 ebuild: "the package name
# without the ebuild revision"; PF is the variable that includes it), so the
# filename stays <PN>-<PV>-retention-unknown-directories.patch across
# -r1 -> -r2 -> -r3 (see packaging/ebuild/README-retention-patch.md).
PATCHES=( "${FILESDIR}/${P}-retention-unknown-directories.patch" )

src_compile() {
	# Patch-outcome gate. Portage's eapply runs `patch -p1 -f -g0` with
	# no -F0 (/usr/lib/portage/python3.14/phase-helpers.sh:1023-1029),
	# so patch reports success even when a hunk lands with fuzz or
	# applies only partially. Assert that the patched sources are
	# byte-exactly what the patch intends: any deviation is fatal here
	# regardless of how patch reported it. The hashes are the three
	# retention source files at fork commit 8ec883878, the commit the
	# shipped patch is cut from.
	#
	# This is also the only thing in the ebuild that distinguishes an
	# r2/r3 payload from r1. The r1 patch carried 16ed06e11, whose
	# isContainedInSwarmRoot() was a prefix check; 8ec883878 changed the
	# body to path.relative(). Both contain the identifier, so the
	# presence greps in src_install pass on either. These hashes do not:
	# 16ed06e11's src/retention/unclaimed.ts has different content, so an
	# r1-era patch dies here. Keep them in step with the patch.
	local unclaimed_sha sweep_sha dir_prune_sha
	unclaimed_sha=d1ce5aa91147e3f34f1524f53231d84c4758821755910047353de0caad01a276
	sweep_sha=4d9476619e05ba9385e246c8256ab3cb99956469f42542afea3548d3176a2888
	dir_prune_sha=045f261eb4f5a1de1f9c870f5b01df2ff3d93afb607c27c6f997343f8471692c

	echo "${unclaimed_sha}  ${S}/src/retention/unclaimed.ts" \
		| sha256sum -c - \
		|| die "retention patch did not apply cleanly: src/retention/unclaimed.ts"
	echo "${sweep_sha}  ${S}/src/retention/sweep.ts" \
		| sha256sum -c - \
		|| die "retention patch did not apply cleanly: src/retention/sweep.ts"
	echo "${dir_prune_sha}  ${S}/src/retention/dir-prune.ts" \
		| sha256sum -c - \
		|| die "retention patch did not apply cleanly: src/retention/dir-prune.ts"

	bun install --frozen-lockfile --ignore-scripts || die "bun install failed"
	bun run build || die "bun run build failed"

	# Ship production dependencies only. `bun run build` needs the
	# devDependencies (tsc, bun-types), but nothing at runtime does, and
	# devDeps dominate the installed tree (typescript, @biomejs/biome,
	# bun-types and their transitive deps).
	#
	# bun 1.3.14 cannot prune an existing tree: `bun install
	# --production` and `NODE_ENV=production bun install` both report
	# "no changes" and leave devDependencies in place (measured). The
	# only reliable route is to clear node_modules and resolve the
	# lockfile again in production mode. `fast-check` is retained by bun
	# because it is a genuine transitive dependency of
	# @opencode-ai/plugin via effect, not because the devDependency
	# survived.
	rm -rf node_modules || die "failed to clear node_modules"
	bun install --frozen-lockfile --production --ignore-scripts \
		|| die "production dependency install failed"
}

src_install() {
	local libdir="$(get_libdir)"
	local module_dir="/usr/${libdir}/node_modules/${PN}"

	insinto "${module_dir}"
	doins -r dist package.json node_modules

	# Prune musl-targeted native prebuilds. @msgpackr-extract ships both
	# glibc and musl variants; on a glibc host the *.musl.node files
	# are never loaded (msgpackr selects via process.report libc probe)
	# but they trip QA Notice: Unresolved soname dependencies because
	# musl’s libc is libc.musl-<arch>.so.1, not libc.so.
	# Deleting them keeps the binpkg lean and the QA log clean.
	find "${ED}/${module_dir}/node_modules" -type f -name '*.musl.node' -delete \
		|| die "musl native binary prune failed"

	# OpenCode v2 directory resolution shim. v2's plugin loader does
	# `require.resolve("<dir>/server")` then falls back to `<dir>/index`
	# (no `dist/` prefix). Upstream only ships `dist/index.js`, so v2
	# silently skipped the package. Install a root-level `server.js`
	# that re-exports the dist entry as both V1 (`server`) and V2
	# (`default`) — keeps the same default export, no functional
	# change for V1 consumers.
	newins "${FILESDIR}/opencode-plugin-swarm-server-shim.js" server.js

	# Patch-presence assertion: prove the retention fix (FILESDIR patch) is
	# actually in the built bundle. The existing smoke block below only
	# proves files exist, which is true with or without the patch. The
	# symbol is the top-level exported function from src/retention/unclaimed.ts;
	# `bun run build` emits an unminified bundle, so the identifier is
	# preserved verbatim and appears twice on one line (definition and
	# call site).
	grep -q 'pruneUnclaimedDirectories' \
		"${ED}/usr/$(get_libdir)/node_modules/${PN}/dist/index.js" \
		|| die "retention fix not present in dist/index.js"

	# Containment-guard presence check. The patch (fork commit 8ec883878,
	# rebased from upstream source 17f92cd56) hardens
	# isContainedInSwarmRoot() in src/retention/unclaimed.ts to a
	# path.relative() check that runs before any unclaimed directory is
	# pruned. The function is not exported, but the bundle is unminified,
	# so the identifier survives verbatim.
	#
	# Presence-only, and on its own it does NOT identify r2/r3: r1's
	# 16ed06e11 already defined isContainedInSwarmRoot() as a
	# `startsWith(resolvedSwarmRoot + path.sep)` prefix test, so this grep
	# passes against the r1 bundle too. The discriminator is the sha256
	# gate at the top of src_compile, which pins the patched sources to
	# 8ec883878 before the bundle is built. Deliberately not asserting
	# `path.relative(` — that is an implementation detail a legitimate
	# refactor may change, and a grep for it would break for no good reason.
	grep -q 'isContainedInSwarmRoot' \
		"${ED}/usr/$(get_libdir)/node_modules/${PN}/dist/index.js" \
		|| die "retention containment guard not present in dist/index.js"

	# Smoke tests: plugin entry + CLI entry + bin manifests must exist and
	# be non-empty. The plugin entry is the OpenCode-loadable target; the
	# CLI entry is bun-only (no shebang) and is invoked explicitly via `bun`.
	[[ -s "${ED}/${module_dir}/dist/index.js" ]] || \
		die "plugin entry dist/index.js missing or empty"
	[[ -s "${ED}/${module_dir}/server.js" ]] || \
		die "v2 server.js shim missing"
	[[ -s "${ED}/${module_dir}/dist/cli/index.js" ]] || \
		die "CLI entry dist/cli/index.js missing or empty"
	[[ -s "${ED}/${module_dir}/package.json" ]] || \
		die "package.json missing"
	[[ -d "${ED}/${module_dir}/node_modules/web-tree-sitter" ]] || \
		die "externalised dep web-tree-sitter not installed"
	[[ -d "${ED}/${module_dir}/node_modules/bash-parser" ]] || \
		die "externalised dep bash-parser not installed"

	# Transitive runtime dependencies. dist/index.js calls
	#   require("ajv/dist/runtime/equal")
	#   require("ajv-formats/dist/formats")
	# but neither package appears in upstream's package.json dependencies
	# (verified against the 7.204.8 distfile): they are satisfied only
	# transitively, today via @modelcontextprotocol/sdk. Nothing in the
	# build would fail if a dependency-graph change dropped them; the
	# plugin would just throw at runtime. Assert the exact files Node
	# resolves for those two requires — not the package directories,
	# which can exist while the dist/ files are missing.
	[[ -f "${ED}/${module_dir}/node_modules/ajv/dist/runtime/equal.js" ]] || \
		die "transitive runtime dep missing: node_modules/ajv/dist/runtime/equal.js (target of require(ajv/dist/runtime/equal))"
	[[ -f "${ED}/${module_dir}/node_modules/ajv-formats/dist/formats.js" ]] || \
		die "transitive runtime dep missing: node_modules/ajv-formats/dist/formats.js (target of require(ajv-formats/dist/formats))"
}

pkg_postinst() {
	einfo "OpenCode Swarm plugin installed at:"
	einfo "  /usr/$(get_libdir)/node_modules/${PN}/dist/index.js"
	einfo ""
	einfo "To enable, add to your opencode.json plugin list:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\""
	einfo ""
	einfo "The CLI entry (dist/cli/index.js) is bun-targeted. Invoke with:"
	einfo "  bun /usr/$(get_libdir)/node_modules/${PN}/dist/cli/index.js <command>"
	einfo ""
	einfo "Upstream's bundled installer also registers the plugin and writes a"
	einfo "starter config; that flow is accessible via the CLI above."
}
