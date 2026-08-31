# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bun

DESCRIPTION="Safety net catching destructive git and filesystem commands for OpenCode"
HOMEPAGE="https://github.com/kenryu42/claude-code-safety-net"
SRC_URI="https://github.com/kenryu42/claude-code-safety-net/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/claude-code-safety-net-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

RDEPEND="
	net-libs/nodejs
"
# Runtime deps (shell-quote) and the bundled OpenCode plugin types come from
# bun install --frozen-lockfile in src_compile (source-based resolution,
# replacing the former MY_NODE_D pre-bundled tarball).
BDEPEND="
	|| ( dev-lang/bun-bin dev-lang/bun )
	net-libs/nodejs
"

src_compile() {
	bun install --frozen-lockfile --ignore-scripts || die "bun install failed"
	bun run build || die "bun run build failed"
}

src_install() {
	dobin dist/bin/cc-safety-net.js

	# The plugin entry (dist/index.js) loads via opencode.json; install the
	# module tree (dist + node_modules for shell-quote) under the standard
	# node_modules path so node resolution works.
	local libdir="$(get_libdir)"
	insinto "/usr/${libdir}/node_modules/${PN}"
	doins -r dist node_modules package.json

	# Smoke test: plugin entry + bin present and executable
	[[ -f "${ED}/usr/${libdir}/node_modules/${PN}/dist/index.js" ]] || \
		die "plugin entry dist/index.js missing"
	[[ -x $(realpath "${ED}/usr/bin/cc-safety-net.js") ]] || \
		die "/usr/bin/cc-safety-net.js target not executable"
}

pkg_postinst() {
	einfo "OpenCode CC Safety Net plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/opencode-plugin-safety-net/dist/index.js\""
}
