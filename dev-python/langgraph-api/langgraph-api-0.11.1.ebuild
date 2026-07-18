# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="langgraph-api"
inherit distutils-r1 pypi

DESCRIPTION="langgraph-api Python package"
HOMEPAGE="https://pypi.org/project/langgraph-api/"

LICENSE="Elastic-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/anyio[${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/grpcio-health-checking[${PYTHON_USEDEP}]
	dev-python/grpcio-tools[${PYTHON_USEDEP}]
	dev-python/grpcio[${PYTHON_USEDEP}]
	dev-python/httptools[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/jsonschema-rs[${PYTHON_USEDEP}]
	dev-python/langchain-core[${PYTHON_USEDEP}]
	dev-python/langgraph-checkpoint[${PYTHON_USEDEP}]
	dev-python/langgraph-runtime-inmem[${PYTHON_USEDEP}]
	dev-python/langgraph-sdk[${PYTHON_USEDEP}]
	dev-python/langgraph[${PYTHON_USEDEP}]
	dev-python/langsmith[${PYTHON_USEDEP}]
	dev-python/opentelemetry-api[${PYTHON_USEDEP}]
	dev-python/opentelemetry-exporter-otlp-proto-http[${PYTHON_USEDEP}]
	dev-python/opentelemetry-sdk[${PYTHON_USEDEP}]
	dev-python/orjson[${PYTHON_USEDEP}]
	dev-python/protobuf[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/sse-starlette[${PYTHON_USEDEP}]
	dev-python/starlette[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/tenacity[${PYTHON_USEDEP}]
	dev-python/truststore[${PYTHON_USEDEP}]
	dev-python/uuid-utils[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/uvloop[${PYTHON_USEDEP}]
	dev-python/watchfiles[${PYTHON_USEDEP}]
	dev-python/zstandard[${PYTHON_USEDEP}]
"

src_prepare() {
	distutils-r1_src_prepare

	# Move stray files into the package directory to avoid QA warnings
	# while keeping them accessible to the code.
	mv openapi.json logging.json langgraph_api/ || die

	# Patch references to moved files
	sed -i 's:parent.parent / "openapi.json":parent / "openapi.json":' \
		langgraph_api/validation.py || die
	sed -i 's:parent.parent / "logging.json":parent / "logging.json":' \
		langgraph_api/queue_entrypoint.py || die

	# Remove forced top-level inclusion from pyproject.toml
	sed -i "/\[tool.hatch.build.targets.wheel.force-include\]/,/hatch_build.py/d" pyproject.toml || die
}
