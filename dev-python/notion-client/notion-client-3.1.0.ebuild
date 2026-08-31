# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="notion-client"
inherit distutils-r1 pypi

DESCRIPTION="Python client for the official Notion API (sync + async)"
HOMEPAGE="https://github.com/ramnes/notion-sdk-py"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/httpx-0.23[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/typing-extensions-4.0[${PYTHON_USEDEP}]' python3_12)
"
