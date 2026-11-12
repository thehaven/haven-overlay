# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# pytorch-metric-learning — source-build notes
# ------------------------------------------------------------------
# Upstream uses a legacy setup.py (no pyproject.toml). PEP 517 is
# still wired through setuptools/wheel.
#
# PyPI stores pytorch-metric-learning under the hyphenated project path
# (not the PEP 503 normalized underscore path). Disable the eclass
# normalization so the URL is fetched from the canonical directory.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="The easiest way to use deep metric learning in your application"
HOMEPAGE="https://github.com/KevinMusgrave/pytorch-metric-learning"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/scikit-learn-1.6[${PYTHON_USEDEP}]
	>=dev-python/torch-2.0[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
