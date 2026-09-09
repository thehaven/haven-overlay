# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Model Context Protocol wire types"
HOMEPAGE="https://github.com/modelcontextprotocol/python-sdk"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/uv-dynamic-versioning[${PYTHON_USEDEP}]
"

RDEPEND="
	>=dev-python/pydantic-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.13.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
