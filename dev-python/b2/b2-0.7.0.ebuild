# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_6 python2_7 python3_3 python3_4 python3_5 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="The command-line tool that gives easy access to all of the capabilities of B2 Cloud Storage"
HOMEPAGE="https://github.com/Backblaze/B2_Command_Line_Tool"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-python/arrow-0.8.0
		>=dev-python/logfury-0.1.2
		>=dev-python/requests-2.9.1
		>=dev-python/six-1.10
		>=dev-python/tqdm-4.5.0
"
RDEPEND="${DEPEND}"

python_test() {
    "${PYTHON}" tests/api_tests.py || die "Testing failed with ${EPYTHON}"
}
