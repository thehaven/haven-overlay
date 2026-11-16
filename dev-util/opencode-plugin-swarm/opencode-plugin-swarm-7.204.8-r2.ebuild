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

BDEPEND="
	|| ( dev-lang/bun-bin dev-lang/bun )
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
# lifecycle plus the path.relative() containment guard and the symlink-swap
# guard on the retention-log compaction path. ${P} has no ebuild revision by
# definition, so the filename stays
# <PN>-<PV>-retention-unknown-directories.patch across -r1 -> -r2 (see
# packaging/ebuild/README-retention-patch.md).
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

	# Containment-guard assertion: the patch (fork commit 8ec883878,
	# rebased from upstream source 17f92cd56) adds
	# isContainedInSwarmRoot() in src/retention/unclaimed.ts, a
	# path.relative() check that runs before any unclaimed directory is
	# pruned. It is not exported, but the bundle is unminified, so the
	# identifier survives verbatim. Without this guard the r2 payload is
	# no different from r1 as far as the patch is concerned.
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
