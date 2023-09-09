# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8
PYTHON_COMPAT=( python3_{9..11} pypy )

inherit distutils-r1 pypi

DESCRIPTION="magzdb.org Downloader."
HOMEPAGE="https://github.com/skyme5/magzdb"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-python/loguru-0.5.3[${PYTHON_USEDEP}]
		>=dev-python/requests-2.24.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
