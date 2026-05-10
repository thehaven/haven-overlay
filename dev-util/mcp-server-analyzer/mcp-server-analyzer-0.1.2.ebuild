# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for Python code analysis (ruff, vulture, bandit)"
HOMEPAGE="https://github.com/anselmoo/mcp-server-analyzer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/fastmcp-0.3.0 >=dev-python/pydantic-2.0.0 dev-python/ruff dev-python/vulture dev-python/bandit"
