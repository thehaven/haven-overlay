# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="minions-node_modules-0.1.15"

DESCRIPTION="Mission Control — AI agent orchestration dashboard with fleet management"
HOMEPAGE="https://github.com/Agent-3-7/minions"
SRC_URI="
	https://github.com/Agent-3-7/minions/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=net-libs/nodejs-18[npm]"

S="${WORKDIR}/minions-${PV}"

src_compile() {
	npm run build || die
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "Minions (Mission Control) installed."
	einfo "Start: cd /usr/$(get_libdir)/node_modules/minions && node dist/server/server/index.js"
	einfo "Web UI: http://localhost:6969"
}
