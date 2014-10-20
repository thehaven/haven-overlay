# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_2,3_3} )
inherit distutils-r1

DESCRIPTION="This Python module returns a tzinfo object with the local timezone information under Unix and Win-32. It requires pytz, and returns pytz tzinfo objects."
HOMEPAGE="https://pypi.python.org/pypi/tzlocal"
SRC_URI="https://pypi.python.org/packages/source/t/tzlocal/tzlocal-${PV}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pytz"
