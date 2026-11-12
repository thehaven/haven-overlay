# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Client library to interact with the Hugging Face Hub"
HOMEPAGE="https://github.com/huggingface/huggingface_hub"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/filelock-3.8[${PYTHON_USEDEP}]
	>=dev-python/fsspec-2023[${PYTHON_USEDEP}]
	>=dev-python/requests-2.30[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.42[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.7[${PYTHON_USEDEP}]
"
