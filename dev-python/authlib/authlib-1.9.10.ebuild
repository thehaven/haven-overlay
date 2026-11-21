# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="authlib"
inherit distutils-r1 pypi

DESCRIPTION="authlib Python package"
HOMEPAGE="https://pypi.org/project/authlib/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/joserfc[${PYTHON_USEDEP}]
"
