# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="@prisma/language-server"

DESCRIPTION="Prisma schema language server"
HOMEPAGE="https://www.npmjs.com/package/@prisma/language-server"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG##*/}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="Apache-2.0"
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
	[[ -L "${bindir}/prisma-language-server" ]] || \
		die "npm install did not create /usr/bin/prisma-language-server"
	[[ -x $(realpath "${bindir}/prisma-language-server") ]] || \
		die "/usr/bin/prisma-language-server target is not executable"
}

pkg_postinst() {
	einfo "prisma-language-server ${PV}: LSP server for Prisma — works with OpenCode"
	einfo "Binary: /usr/bin/prisma-language-server"
}
