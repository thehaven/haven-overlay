# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for Python code analysis (ruff, vulture, bandit)"
HOMEPAGE="https://github.com/anselmoo/mcp-server-analyzer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/fastmcp-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.0.0[${PYTHON_USEDEP}]
	dev-util/ruff
	dev-python/vulture[${PYTHON_USEDEP}]
	dev-python/bandit[${PYTHON_USEDEP}]
"
