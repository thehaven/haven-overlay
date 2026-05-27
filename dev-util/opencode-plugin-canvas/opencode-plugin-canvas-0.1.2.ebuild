# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="${PN}-node_modules-${PV}"
DESCRIPTION="Interactive terminal canvases for OpenCode"
HOMEPAGE="https://github.com/mailshieldai/opencode-canvas"
SRC_URI="
	https://github.com/mailshieldai/opencode-canvas/archive/080489664f59ea80f1548edd1f4bdbe3dbeaeaac.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"
S="${WORKDIR}/opencode-canvas-080489664f59ea80f1548edd1f4bdbe3dbeaeaac"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"

src_compile() {
	ln -s "${WORKDIR}/node_modules" node_modules || die
	bun run build || die
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "opencode-plugin-canvas installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\" }"
}
