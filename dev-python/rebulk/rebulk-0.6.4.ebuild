# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Define simple search patterns in bulk to perform advanced matching on any string"
HOMEPAGE="https://github.com/Toilal/rebulk"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Dev dependancies:
#dev-python/pylint
#>=dev-python/pytest-2.7.3
#dev-python/pytest-capturelog
#dev-python/tox

DEPEND=""
RDEPEND="${DEPEND}"
