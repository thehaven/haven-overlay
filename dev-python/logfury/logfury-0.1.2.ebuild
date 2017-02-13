# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 python3_3 python3_4 python3_5 python3_6 pypy )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Responsible, low-boilerplate logging of method calls for python libraries"
HOMEPAGE="https://github.com/ppolewicz/logfury"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/six-1.10
		dev-python/funcsigs
"
RDEPEND="${DEPEND}"

python_test() {
    "${PYTHON}" tests/api_tests.py || die "Testing failed with ${EPYTHON}"
}
