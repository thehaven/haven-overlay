# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Network traffic analyzer with web interface"
HOMEPAGE="http://www.ntop.org/"

inherit autotools versionator

if [[ ${PV} == "9999" ]]
	then
		inherit subversion
		ESVN_REPO_URI="https://svn.ntop.org/svn/ntop/trunk/ntopng/"
		ESVN_REPO_URI="https://svn.ntop.org/svn/ntop/trunk/ntopng/"
		ESVN_BOOTSTRAP=""
	else
		SRC_URI="mirror://sourceforge/ntop/${PN}/${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

COMMON_DEPEND="dev-libs/glib
dev-db/credis
dev-libs/geoip
dev-libs/json-c
>=net-analyzer/rrdtool-1.4.7
>=net-libs/zeromq-3.2.3
virtual/pkgconfig"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
dev-db/redis"

src_install()
{
	SHARE_NTOPNG_DIR="/usr/share/${PN}"
	dodir ${SHARE_NTOPNG_DIR} || die "Failed creating ${PN} shared directory"
	insinto ${SHARE_NTOPNG_DIR}
	doins -r httpdocs || die "Failed installing ${PN} httpdocs"
	doins -r scripts || die "Failed installing ${PN} scripts"

	# ntopng has hardcoded path in source code so we make this link to make him happy
	dosym ${SHARE_NTOPNG_DIR} /usr/local/share/${PN}

	exeinto /usr/bin
	doexe ${PN} || die "Failed installing the main executable failed"

	doman ${PN}.8 || die "Failed installing the man failed"
}

pkg_postinst()
{
	elog "ntopng default creadential are user='admin' password='admin'"
}
