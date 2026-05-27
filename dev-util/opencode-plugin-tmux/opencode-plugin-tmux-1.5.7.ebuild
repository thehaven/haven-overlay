# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="${PN}-node_modules-${PV}"
DESCRIPTION="OpenCode tmux integration: automatically opens subagent panes"
HOMEPAGE="https://github.com/AnganSamadder/opentmux"
SRC_URI="
	https://github.com/AnganSamadder/opentmux/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"
S="${WORKDIR}/opentmux-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"

src_compile() {
	# Vendor tarball gives us the node_modules
	ln -s "${WORKDIR}/node_modules" node_modules || die
	bun run build || die
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "opencode-plugin-tmux installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\" }"
}
