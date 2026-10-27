# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for quota tracking"
HOMEPAGE="https://github.com/slkiser/opencode-quota"
SRC_URI="https://registry.npmjs.org/@slkiser/opencode-quota/-/opencode-quota-6.0.0.tgz -> opencode-plugin-quota-6.0.0.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"

RDEPEND=">=net-libs/nodejs-20"

PATCHES=(
	"${FILESDIR}/${P}-opencode-v2-db.patch"
)

src_compile() {
	npm install --omit=dev --audit=false --ignore-scripts --legacy-peer-deps || die "npm install failed"
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json node_modules
	newins "${FILESDIR}/${P}-server-shim.js" server.js
}

pkg_postinst() {
	einfo "opencode-plugin-quota installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\""
}
