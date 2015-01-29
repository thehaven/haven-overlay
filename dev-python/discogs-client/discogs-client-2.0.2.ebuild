# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/discogs-client/discogs-client-2.0.2.ebuild,v 1.1 2014/09/30 03:17:52 idella4 Exp $

EAPI=5
# Not py3 capable due to oauth2 supports py2 pypy only
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Official Python API client for Discogs"
HOMEPAGE="http://github.com/discogs/discogs_client http://pypi.python.org/pypi/discogs-client"
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/discogs/${PN/-/_}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]
		|| ( dev-python/oauth2[${PYTHON_USEDEP}] dev-python/python3-oauth2[${PYTHON_USEDEP}] )"
# It's either this or make a test use flag to add RDEPEND behind it. Both work
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${P/-/_}

python_test() {
	"${PYTHON}" -m unittest discover || die "Tests failed under ${EPYTHON}"
}
