# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for semantic context pruning"
HOMEPAGE="https://github.com/Opencode-DCP/opencode-dynamic-context-pruning"
SRC_URI="https://github.com/Opencode-DCP/opencode-dynamic-context-pruning/archive/refs/heads/master.tar.gz -> opencode-dynamic-context-pruning-master.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/opencode-dynamic-context-pruning-master"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building dynamic-context-pruning..."
	bun run build || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "opencode-plugin-dcp installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/lib/node_modules/${PN}/dist/index.js\" }"
}
