# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="sse-starlette"
inherit distutils-r1 pypi

DESCRIPTION="sse-starlette Python package"
HOMEPAGE="https://github.com/sysid/sse-starlette"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/starlette[${PYTHON_USEDEP}]
	dev-python/anyio[${PYTHON_USEDEP}]
"
