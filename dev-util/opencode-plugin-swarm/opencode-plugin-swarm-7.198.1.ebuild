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

PATCHES=(
	"${FILESDIR}/${P}-fast-activation.patch"
	"${FILESDIR}/${P}-worktree-authority.patch"
	"${FILESDIR}/${P}-acceptance-auto-inject.patch"
)

src_compile() {
	bun install --frozen-lockfile --ignore-scripts || die "bun install failed"
	bun run build || die "bun run build failed"
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
	newins "${FILESDIR}/${P}-server-shim.js" server.js

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
