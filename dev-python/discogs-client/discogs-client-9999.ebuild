# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# Not py3 capable due to oauth2 supports py2 pypy only
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Official Python API client for Discogs"
HOMEPAGE="https://github.com/discogs/discogs_client https://pypi.python.org/pypi/discogs-client"
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/discogs/${PN/-/_}/archive/master.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="-*"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	"
# It's either this or make a test use flag to add RDEPEND behind it. Both work
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]"

if [[ ${PV} = *9999* ]]; then
  S="${WORKDIR}/discogs_client-master"
fi

python_test() {
	"${PYTHON}" -m unittest discover || die "Tests failed under ${EPYTHON}"
}
