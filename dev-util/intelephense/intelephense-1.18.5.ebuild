# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="intelephense"

DESCRIPTION="A PHP language server"
HOMEPAGE="https://www.npmjs.com/package/intelephense"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG}-${PV}.tgz -> ${P}.tgz"
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
	[[ -L "${bindir}/intelephense" ]] || \
		die "npm install did not create /usr/bin/intelephense"
	[[ -x $(realpath "${bindir}/intelephense") ]] || \
		die "/usr/bin/intelephense target is not executable"
}

pkg_postinst() {
	einfo "intelephense ${PV}: LSP server for PHP — works with OpenCode"
	einfo "Binary: /usr/bin/intelephense"
}
