# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NIS Server and Schema Compatibility plug-ins for Directory Server"
HOMEPAGE="https://github.com/freeipa/slapi-nis"
SRC_URI="https://releases.pagure.org/slapi-nis/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	net-nds/389-ds-base
"
RDEPEND="${DEPEND}"

src_compile() {
	# Stub compile
	true
}

src_install() {
	# Stub install
	einstalldocs
}
