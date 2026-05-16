# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 pypi

DESCRIPTION="A fast PostgreSQL client library for Python/asyncio"
HOMEPAGE="https://github.com/MagicStack/asyncpg"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Needs cython to build from sdist usually
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
