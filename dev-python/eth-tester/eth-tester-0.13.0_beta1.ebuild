# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="eth-tester"
inherit distutils-r1 pypi

DESCRIPTION="eth-tester Python package"
HOMEPAGE="https://github.com/ethereum/eth-tester"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/eth-abi[${PYTHON_USEDEP}]
	dev-python/eth-account[${PYTHON_USEDEP}]
	dev-python/eth-keys[${PYTHON_USEDEP}]
	dev-python/eth-utils[${PYTHON_USEDEP}]
	dev-python/rlp[${PYTHON_USEDEP}]
	dev-python/semantic-version[${PYTHON_USEDEP}]
	dev-python/py-evm[${PYTHON_USEDEP}]
	dev-python/py-evm[${PYTHON_USEDEP}]
	dev-python/eth-hash[${PYTHON_USEDEP}]
	dev-python/eth-hash[${PYTHON_USEDEP}]
	dev-python/py-evm[${PYTHON_USEDEP}]
	dev-python/eth-hash[${PYTHON_USEDEP}]
	dev-python/eth-hash[${PYTHON_USEDEP}]
"
