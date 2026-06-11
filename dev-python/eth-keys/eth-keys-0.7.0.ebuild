# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="eth-keys"
inherit distutils-r1 pypi

DESCRIPTION="eth-keys Python package"
HOMEPAGE="https://github.com/ethereum/eth-keys"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/eth-utils[${PYTHON_USEDEP}]
	dev-python/eth-typing[${PYTHON_USEDEP}]
"
