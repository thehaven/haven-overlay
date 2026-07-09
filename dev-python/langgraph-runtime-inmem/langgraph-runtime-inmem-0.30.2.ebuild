# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="langgraph-runtime-inmem"
inherit distutils-r1 pypi

DESCRIPTION="langgraph-runtime-inmem Python package"
HOMEPAGE="https://pypi.org/project/langgraph-runtime-inmem/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/blockbuster[${PYTHON_USEDEP}]
	dev-python/croniter[${PYTHON_USEDEP}]
	dev-python/langgraph-checkpoint[${PYTHON_USEDEP}]
	dev-python/langgraph[${PYTHON_USEDEP}]
	dev-python/sse-starlette[${PYTHON_USEDEP}]
	dev-python/starlette[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
"
