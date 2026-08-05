# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="aiofile"
inherit distutils-r1 pypi

DESCRIPTION="aiofile Python package"
HOMEPAGE="https://github.com/mosquito/aiofile"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/caio[${PYTHON_USEDEP}]
"
