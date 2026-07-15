# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="openai-whisper"
inherit distutils-r1 pypi

DESCRIPTION="Robust Speech Recognition via Large-Scale Weak Supervision (OpenAI Whisper)"
HOMEPAGE="https://github.com/openai/whisper"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# openai-whisper imports torch unconditionally at runtime; this dep is mandatory.
# dev-python/torch is not yet packaged in this overlay; emerge will fail until
# it is added. See dev-python/pydantic-core for the maturin-based torch
# approach (vendor a wheel).
RDEPEND="
	>=dev-python/torch-2.0[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.23[${PYTHON_USEDEP}]
	>=dev-python/tiktoken-0.6[${PYTHON_USEDEP}]
	>=dev-python/numba-0.57[${PYTHON_USEDEP}]
	>=dev-python/llvmlite-0.40[${PYTHON_USEDEP}]
	>=dev-python/fsspec-2023[${PYTHON_USEDEP}]
	dev-python/more-itertools[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"
