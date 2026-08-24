# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="ACP runtime plugin for Paperclip"
HOMEPAGE="https://github.com/mvanhorn/paperclip-plugin-acp"
SRC_URI="https://registry.npmjs.org/paperclip-plugin-acp/-/paperclip-plugin-acp-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=net-libs/nodejs-20[npm]"
RDEPEND="
	>=net-libs/nodejs-20
	app-misc/paperclipai
"

src_compile() { :; }

src_install() {
	npm install --global --prefix "${ED}/usr" "${DISTDIR}/${A}" || die
	einstalldocs
}
