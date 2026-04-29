# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="LDAP back-end plug-in for BIND"
HOMEPAGE="https://github.com/freeipa/bind-dyndb-ldap"
SRC_URI="https://github.com/freeipa/bind-dyndb-ldap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	net-dns/bind
	net-nds/openldap
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
