# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 git-r3

DESCRIPTION="Context & Safety Proxy for LLM requests"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/ai-compressor"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/ai-compressor.git"

KEYWORDS=""
LICENSE="Proprietary"
SLOT="0"

RDEPEND="
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/redis[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tiktoken[${PYTHON_USEDEP}]
	dev-python/rank-bm25[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
