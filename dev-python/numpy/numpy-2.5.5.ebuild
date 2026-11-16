# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Fundamental package for array computing in Python"
HOMEPAGE="https://numpy.org"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fortran"

QA_FLAGS_IGNORED=".*"

BDEPEND="
	>=dev-python/cython-3.0[${PYTHON_USEDEP}]
	dev-python/meson-python[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyproject-metadata[${PYTHON_USEDEP}]
"
DEPEND="fortran? ( virtual/fortran )"
