# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="uuid-utils"
inherit distutils-r1 pypi

DESCRIPTION="uuid-utils Python package"
HOMEPAGE="https://pypi.org/project/uuid-utils/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

