# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# lightning (PyTorch Lightning) — source-build notes
# ------------------------------------------------------------------
# Upstream is a monorepo that builds three packages from one source
# tree (lightning, pytorch_lightning, lightning_fabric). The sdist
# carries the assembled lightning package directly; the setup.py
# script merges requirements/{fabric,pytorch}/base.txt into a single
# install_requires at build time.
#
# The user-requested minimum RDEPEND is preserved verbatim; a full
# runtime will additionally need >=dev-python/lightning-utilities-0.10,
# >=dev-python/pyyaml-5.4, >=dev-python/tqdm-4.57, >=dev-python/fsspec-2022.5,
# and >=dev-python/torchmetrics-0.7 (pulled in transitively from
# upstream's requirements). These are not added as hard RDEPEND here
# because the user's spec is the authoritative source.
#
# This ebuild only declares the lightning aggregator (the meta-package
# that re-exports lightning.pytorch and lightning.fabric). The
# underlying lightning-fabric and pytorch-lightning packages exist as
# separate PyPI projects for cases where the aggregator is not wanted.
# ------------------------------------------------------------------

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="PyTorch Lightning: lightweight PyTorch wrapper for high-performance AI research"
HOMEPAGE="https://github.com/Lightning-AI/pytorch-lightning"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/torch-2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/packaging-23[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.7[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
