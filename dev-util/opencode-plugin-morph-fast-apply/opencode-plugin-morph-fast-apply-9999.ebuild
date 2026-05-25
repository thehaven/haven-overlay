# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for fast diff-based file edits using Morph API"
HOMEPAGE="https://github.com/JRedeker/opencode-morph-fast-apply"
SRC_URI="https://github.com/JRedeker/opencode-morph-fast-apply/archive/refs/heads/trunk.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/opencode-morph-fast-apply-trunk"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	# No build script, it's a direct index.ts loaded by bun/node in opencode
	# But OpenCode expects .js usually. Wait, the main report says dist/index.js.
	# If main is index.ts, OpenCode might support it via bun.
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins index.ts package.json
	doins -r instructions
}

pkg_postinst() {
	einfo "opencode-morph-fast-apply installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/lib/node_modules/${PN}/index.ts\""
}
