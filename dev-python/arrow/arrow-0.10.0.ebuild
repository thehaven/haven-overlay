# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 python3_3 python3_4 python3_5 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Better dates & times for Python https://arrow.readthedocs.org"
HOMEPAGE="https://github.com/crsmithdev/arrow/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=dev-python/python-dateutil-2.6.0
		=dev-python/nose-0.1.3
		=dev-python/chai-1.1.1
		=dev-python/sphinx-1.3.5
		=dev-python/simplejson-3.6.5
"
RDEPEND="${DEPEND}"

python_test() {
    "${PYTHON}" tests/api_tests.py || die "Testing failed with ${EPYTHON}"
}
