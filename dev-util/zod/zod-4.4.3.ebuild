# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="TypeScript-first schema declaration and validation library"
HOMEPAGE="https://zod.dev"
SRC_URI="https://registry.npmjs.org/zod/-/zod-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"

src_install() {
	insinto "/usr/$(get_libdir)/node_modules/${PN}"
	doins -r . || die
}

pkg_postinst() {
	einfo "zod ${PV}: TypeScript-first schema declaration and validation"
	einfo "Installed to /usr/$(get_libdir)/node_modules/zod/"
}
