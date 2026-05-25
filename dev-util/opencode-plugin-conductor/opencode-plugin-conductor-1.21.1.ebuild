# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for multi-agent task dispatch"
HOMEPAGE="https://github.com/derekbar90/opencode-conductor"
SRC_URI="https://github.com/derekbar90/opencode-conductor/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Needs network for npm/bun install --ignore-scripts
RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/opencode-conductor-${PV}"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building plugin..."
	bun run build || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
	
	dodoc README.md
}

pkg_postinst() {
	einfo "opencode-plugin-conductor ${PV} installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/lib/node_modules/${PN}/dist/index.js\""
}
