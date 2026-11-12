# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="langgraph-sdk"
inherit distutils-r1 pypi

DESCRIPTION="langgraph-sdk Python package"
HOMEPAGE="https://pypi.org/project/langgraph-sdk/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/orjson[${PYTHON_USEDEP}]
"
