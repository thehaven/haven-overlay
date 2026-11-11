# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 pypi

DESCRIPTION="Programming (not prompting) framework for language models"
HOMEPAGE="https://github.com/stanfordnlp/dspy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Upstream test suite requires live LLM API access (dev extra even pulls
# litellm[proxy]); not runnable offline.
RESTRICT="test"

# Core dependencies from pyproject.toml. Upstream pins gepa[dspy]==0.1.1
# exactly (the dspy extra is undeclared in gepa metadata, so the plain
# package satisfies it). litellm capped at <1.92 because the overlay's
# 1.92+ ebuilds declare a poetry backend while upstream is maturin
# (build failure).
RDEPEND="
	>=dev-python/openai-1.66.2[${PYTHON_USEDEP}]
	>=dev-python/regex-2023.10.3[${PYTHON_USEDEP}]
	dev-python/orjson[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.66.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.31.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.0[${PYTHON_USEDEP}]
	>=dev-python/litellm-1.65.8[${PYTHON_USEDEP}]
	<dev-python/litellm-1.92[${PYTHON_USEDEP}]
	>=dev-python/diskcache-5.6.0[${PYTHON_USEDEP}]
	>=dev-python/json-repair-0.54.2[${PYTHON_USEDEP}]
	>=dev-python/tenacity-8.2.3[${PYTHON_USEDEP}]
	dev-python/anyio[${PYTHON_USEDEP}]
	>=dev-python/cachetools-5.5.0[${PYTHON_USEDEP}]
	>=dev-python/cloudpickle-3.1.2[${PYTHON_USEDEP}]
	=dev-python/gepa-0.1.1-r0[${PYTHON_USEDEP}]
"
