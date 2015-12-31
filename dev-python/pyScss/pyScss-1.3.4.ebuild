# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="pyScss, a Scss compiler for Python"
HOMEPAGE="https://github.com/Kronuz/pyScss"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

python_test() {
    "${PYTHON}" tests/api_tests.py || die "Testing failed with ${EPYTHON}"
}
