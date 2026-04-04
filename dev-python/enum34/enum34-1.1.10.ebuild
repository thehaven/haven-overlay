# Copyright 2013-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Python 3.4 Enum backported to older versions"
HOMEPAGE="https://pypi.python.org/pypi/enum34 https://bitbucket.org/stoneleaf/enum34"
SRC_URI="https://files.pythonhosted.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCS=( enum/doc/enum.rst enum/README enum/LICENSE )
