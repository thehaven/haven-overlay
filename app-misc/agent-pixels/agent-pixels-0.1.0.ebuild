# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Visual feedback layer for Paperclip agents"
HOMEPAGE="https://github.com/gcampton/Agent-Pixels"
SRC_URI="https://github.com/gcampton/Agent-Pixels/archive/refs/heads/main.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND="
	>=net-libs/nodejs-20[npm]
"
RDEPEND="
	>=net-libs/nodejs-20
	app-misc/paperclipai
"

S="${WORKDIR}/Agent-Pixels-main"

src_compile() {
	npm install || die
	npm run build || die
}

src_install() {
	insinto /usr/lib64/node_modules/@gcampton/agent-pixels
	doins -r dist package.json
	einstalldocs
}

pkg_postinst() {
	elog "To enable Agent Pixels in Paperclip:"
	elog "Run: paperclipai plugin add /usr/lib64/node_modules/@gcampton/agent-pixels"
}
