# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="trie"
inherit distutils-r1 pypi

DESCRIPTION="trie Python package"
HOMEPAGE="https://github.com/ethereum/py-trie"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/eth-utils[${PYTHON_USEDEP}]
	dev-python/hexbytes[${PYTHON_USEDEP}]
	dev-python/rlp[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
	dev-python/eth-hash[${PYTHON_USEDEP}]
"
