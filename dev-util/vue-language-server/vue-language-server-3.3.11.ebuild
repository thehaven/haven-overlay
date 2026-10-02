# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="@vue/language-server"

DESCRIPTION="Vue language server"
HOMEPAGE="https://www.npmjs.com/package/@vue/language-server"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG##*/}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die

	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/vue-language-server" ]] || \
		die "npm install did not create /usr/bin/vue-language-server"
	[[ -x $(realpath "${bindir}/vue-language-server") ]] || \
		die "/usr/bin/vue-language-server target is not executable"
}

pkg_postinst() {
	einfo "vue-language-server ${PV}: LSP server for Vue — works with OpenCode"
	einfo "Binary: /usr/bin/vue-language-server"
}
