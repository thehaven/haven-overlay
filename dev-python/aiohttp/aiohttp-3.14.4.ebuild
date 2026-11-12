# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Async HTTP client/server framework for asyncio and Python"
HOMEPAGE="https://github.com/aio-libs/aiohttp"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED=".*"

RDEPEND="
	>=dev-python/aiosignal-1.4[${PYTHON_USEDEP}]
	>=dev-python/frozenlist-1.4[${PYTHON_USEDEP}]
	>=dev-python/multidict-6.0[${PYTHON_USEDEP}]
	>=dev-python/yarl-1.10[${PYTHON_USEDEP}]
	dev-python/aiohappyeyeballs[${PYTHON_USEDEP}]
	dev-python/attrs[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
"
