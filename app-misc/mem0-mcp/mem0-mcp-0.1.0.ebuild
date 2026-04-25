# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 git-r3

DESCRIPTION="FastMCP server for Mem0 memory layer"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/mem0-mcp.git"

if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="v${PV}"
	KEYWORDS="~amd64 ~arm64"
else
	KEYWORDS=""
fi

LICENSE="Proprietary"
SLOT="0"

RDEPEND="
	dev-python/mem0ai[${PYTHON_USEDEP}]
	dev-python/fastmcp[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/qdrant-client[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/redis[${PYTHON_USEDEP}]
	dev-python/psycopg2-binary[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	dev-python/fastembed[${PYTHON_USEDEP}]
	dev-python/neo4j[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/passlib[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
