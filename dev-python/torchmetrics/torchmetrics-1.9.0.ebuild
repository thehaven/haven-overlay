# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# torchmetrics — source-build notes
# ------------------------------------------------------------------
# Upstream uses a setup.py that aggregates requirements/*.txt into a
# single install_requires. No pyproject.toml is published; PEP 517 is
# wired through setuptools + wheel.
#
# Upstream pins `torch <2.9.0` while this overlay ships torch-2.10.0.
# The hard upper bound is dropped on a normal pip install (see
# FREEZE_REQUIREMENTS env handling in setup.py); our DISTUTILS_USE_PEP517
# path does the same, so no patch is required.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="PyTorch native metrics"
HOMEPAGE="https://github.com/Lightning-AI/torchmetrics"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/torch-2.0[${PYTHON_USEDEP}]
	>=dev-python/lightning-utilities-0.15.3[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
