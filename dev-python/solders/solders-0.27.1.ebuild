# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="solders"
inherit distutils-r1 pypi

DESCRIPTION="solders Python package"
HOMEPAGE="https://pypi.org/project/solders/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/jsonalias[${PYTHON_USEDEP}]
"
