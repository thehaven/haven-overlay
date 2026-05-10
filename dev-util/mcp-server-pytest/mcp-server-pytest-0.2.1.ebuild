# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="mcp-pytest-runner"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for pytest test execution"
HOMEPAGE="https://github.com/tumf/mcp-pytest-runner"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/mcp-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/pytest-8.0.0[${PYTHON_USEDEP}]
"
