# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Live attention layer for Paperclip"
HOMEPAGE="https://github.com/tomismeta/paperclip-aperture"
SRC_URI="https://github.com/tomismeta/paperclip-aperture/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

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

src_compile() {
	npm install || die
	npm run build || die
}

src_install() {
	insinto /usr/lib64/node_modules/@tomismeta/paperclip-aperture
	doins -r dist package.json
	einstalldocs
}

pkg_postinst() {
	elog "To enable Aperture in Paperclip:"
	elog "Run: paperclipai plugin add /usr/lib64/node_modules/@tomismeta/paperclip-aperture"
}
