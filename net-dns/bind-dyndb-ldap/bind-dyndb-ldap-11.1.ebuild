# Copyright 1999-2026 Gentoo Authors
# Distributed under terms GNU General Public License v2

EAPI=8

DESCRIPTION="LDAP back-end plug-in BIND"
HOMEPAGE="https://github.com/freeipa/bind-dyndb-ldap"
# Upstream tags releases v<major>.<minor> (v11.1 tracks BIND 9.11.1). The old
# releases.pagure.org host is gone, so fetch the upstream GitHub tag archive;
# GitHub strips the leading "v" from the archive directory name.
SRC_URI="https://github.com/freeipa/bind-dyndb-ldap/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

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
