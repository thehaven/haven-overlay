# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode secret protection plugin preventing reads of sensitive credentials"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/gentoo/haven-overlay"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"

src_unpack() {
	mkdir -p "${S}" || die
}

src_install() {
	local mod="/usr/$(get_libdir)/node_modules/${PN}"
	insinto "${mod}"
	doins "${FILESDIR}/package.json"
	doins "${FILESDIR}/server.js"
	insinto "${mod}/dist"
	newins "${FILESDIR}/index.js" index.js
}
