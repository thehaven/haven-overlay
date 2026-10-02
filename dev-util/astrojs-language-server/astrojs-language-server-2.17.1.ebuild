# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="@astrojs/language-server"

DESCRIPTION="Astro language server"
HOMEPAGE="https://www.npmjs.com/package/@astrojs/language-server"
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
	[[ -L "${bindir}/astro-ls" ]] || \
		die "npm install did not create /usr/bin/astro-ls"
	[[ -x $(realpath "${bindir}/astro-ls") ]] || \
		die "/usr/bin/astro-ls target is not executable"
}

pkg_postinst() {
	einfo "astrojs-language-server ${PV}: LSP server for Astro — works with OpenCode"
	einfo "Binary: /usr/bin/astro-ls"
}
