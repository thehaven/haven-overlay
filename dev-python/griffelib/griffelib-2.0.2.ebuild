# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="griffelib"
inherit distutils-r1 pypi

BDEPEND="dev-python/uv-dynamic-versioning[${PYTHON_USEDEP}]"

DESCRIPTION="griffelib Python package"
HOMEPAGE="https://pypi.org/project/griffelib/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

