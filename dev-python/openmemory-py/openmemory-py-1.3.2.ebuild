# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="openmemory-py"
inherit distutils-r1 pypi

DESCRIPTION="OpenMemory Python SDK — self-hosted long-term memory for AI agents"
HOMEPAGE="https://github.com/CaviraOSS/LongMemory"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/fastapi[${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.30[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27[${PYTHON_USEDEP}]
	>=dev-python/google-api-python-client-2.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-2.0[${PYTHON_USEDEP}]
	>=dev-python/notion-client-2.0[${PYTHON_USEDEP}]
	>=dev-python/msal-1.0[${PYTHON_USEDEP}]
	>=dev-python/pygithub-2.0[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup4-4.0[${PYTHON_USEDEP}]
	>=dev-python/pypdf-4.0[${PYTHON_USEDEP}]
	>=dev-python/mammoth-1.6[${PYTHON_USEDEP}]
	>=dev-python/markdownify-0.11[${PYTHON_USEDEP}]
	>=dev-python/openai-1.0[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-1.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	>=dev-python/qdrant-client-1.19.0[${PYTHON_USEDEP}]
"
