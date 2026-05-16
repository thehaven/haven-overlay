# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Paperclip adapter for Hermes Agent"
HOMEPAGE="https://github.com/NousResearch/hermes-paperclip-adapter"
SRC_URI="https://registry.npmjs.org/hermes-paperclip-adapter/-/hermes-paperclip-adapter-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=net-libs/nodejs-20[npm]"
RDEPEND="
	>=net-libs/nodejs-20
	app-misc/hermes-agent
"

src_compile() { :; }

src_install() {
	npm install --global --prefix "${ED}/usr" "${DISTDIR}/${A}" || die
	einstalldocs
}
