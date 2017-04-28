# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5,3_6} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Python implementation of Dropbox's realistic password strength estimator, zxcvbn"
HOMEPAGE="https://github.com/dwolfhub/zxcvbn-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/py-1.4.31"
RDEPEND="${DEPEND}"

python_test() {
    "${PYTHON}" tests/api_tests.py || die "Testing failed with ${EPYTHON}"
}
