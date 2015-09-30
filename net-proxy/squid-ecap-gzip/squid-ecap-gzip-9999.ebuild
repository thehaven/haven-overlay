# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit git-r3 eutils
EGIT_REPO_URI="	git@github.com:c-rack/squid-ecap-gzip.git
				https://github.com/c-rack/squid-ecap-gzip.git"

DESCRIPTION="SQUID eCAP GZIP Adapter"
HOMEPAGE="https://github.com/c-rack/squid-ecap-gzip"

LICENSE="GPL-2"
SLOT="0"

DEPEND="net-libs/libecap
		net-proxy/squid"
RDEPEND="${DEPEND}"
