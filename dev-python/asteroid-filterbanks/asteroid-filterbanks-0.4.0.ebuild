# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

# PyPI stores asteroid-filterbanks under the hyphenated project path
# (not the PEP 503 normalized underscore path). Disable the eclass
# normalization so the URL is fetched from the canonical directory.
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Filterbanks building blocks for PyTorch audio separation models (Asteroid)"
HOMEPAGE="https://github.com/asteroid-team/asteroid-filterbanks"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/torch-1.13[${PYTHON_USEDEP}]
	>=dev-python/scipy-1.10[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
