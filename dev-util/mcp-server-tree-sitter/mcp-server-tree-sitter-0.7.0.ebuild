# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for tree-sitter AST analysis"
HOMEPAGE="https://github.com/wrale/mcp-server-tree-sitter"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/h11 dev-python/mcp dev-python/pydantic dev-python/pygments dev-python/pyyaml dev-python/starlette dev-python/tree-sitter-language-pack dev-python/tree-sitter"
