# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="py-evm"
inherit distutils-r1 pypi

DESCRIPTION="py-evm Python package"
HOMEPAGE="https://github.com/ethereum/py-evm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/cached-property[${PYTHON_USEDEP}]
	dev-python/eth-bloom[${PYTHON_USEDEP}]
	dev-python/eth-keys[${PYTHON_USEDEP}]
	dev-python/eth-typing[${PYTHON_USEDEP}]
	dev-python/eth-utils[${PYTHON_USEDEP}]
	dev-python/lru-dict[${PYTHON_USEDEP}]
	dev-python/py-ecc[${PYTHON_USEDEP}]
	dev-python/rlp[${PYTHON_USEDEP}]
	dev-python/trie[${PYTHON_USEDEP}]
	dev-python/ckzg[${PYTHON_USEDEP}]
	dev-python/py-evm[${PYTHON_USEDEP}]
	dev-python/py-evm[${PYTHON_USEDEP}]
"
