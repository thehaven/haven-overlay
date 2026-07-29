# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Dogtag Public Key Infrastructure (PKI) Suite"
HOMEPAGE="https://github.com/dogtagpki/pki"
SRC_URI="https://github.com/dogtagpki/pki/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=virtual/jre-17
	dev-java/tomcat
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
