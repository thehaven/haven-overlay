# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Apache module to handle GSSAPI authentication"
HOMEPAGE="https://github.com/gssapi/mod_auth_gssapi"
SRC_URI="https://github.com/gssapi/mod_auth_gssapi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	www-servers/apache
	virtual/krb5
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
