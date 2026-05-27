# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_NODE_D="hermes-workspace-node_modules-2.3.0"

DESCRIPTION="Web-based workspace for Hermes Agent with chat, terminal, skills manager"
HOMEPAGE="https://github.com/outsourc-e/hermes-workspace"
SRC_URI="
	https://github.com/outsourc-e/hermes-workspace/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://artifactory.thehavennet.org.uk/artifactory/gentoo-mirror/distfiles/${MY_NODE_D}.tar.xz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=net-libs/nodejs-22"

S="${WORKDIR}/hermes-workspace-${PV}"

src_compile() {
	NODE_OPTIONS="--max-old-space-size=2048" node node_modules/.bin/vite build || die
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json server-entry.js
}

pkg_postinst() {
	einfo "Hermes Workspace installed."
	einfo "Start: cd /usr/$(get_libdir)/node_modules/hermes-workspace && node server-entry.js"
	einfo "Web UI: http://localhost:3000"
	einfo "Requires hermes-agent or OpenAI-compatible API."
}
