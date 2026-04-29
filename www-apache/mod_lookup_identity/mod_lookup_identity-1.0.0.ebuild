# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Apache module to lookup user identity"
HOMEPAGE="https://github.com/adelton/mod_lookup_identity"
SRC_URI="https://github.com/adelton/mod_lookup_identity/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	www-servers/apache
	sys-auth/sssd
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
