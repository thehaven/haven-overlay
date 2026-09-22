# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="a2a-sdk"

# a2a-sdk is the official Python SDK for the Agent2Agent protocol.
# Used by opencode-a2a and other agent-to-agent integration code.
inherit distutils-r1 optfeature pypi

DESCRIPTION="Official Python SDK for the Agent2Agent (A2A) protocol"
HOMEPAGE="
	https://github.com/a2a-mcp/a2a-python
	https://pypi.org/project/a2a-sdk/
"
SRC_URI="https://files.pythonhosted.org/packages/source/a/a2a-sdk/a2a_sdk-${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/a2a_sdk-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Core runtime deps only; optional extras (fastapi, http-server, sql, etc.)
# are surfaced as optfeatures in pkg_postinst.
# culsans is required only on cpython < 3.13 (uses 3.13+ stdlib
# primitives otherwise).
RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/httpx-sse[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.11.3[${PYTHON_USEDEP}]
	>=dev-python/protobuf-5.29.5[${PYTHON_USEDEP}]
	<dev-python/protobuf-7[${PYTHON_USEDEP}]
	>=dev-python/google-api-core-1.26.0[${PYTHON_USEDEP}]
	>=dev-python/json-rpc-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/googleapis-common-protos-1.70.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-24.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/culsans-0.11.0[${PYTHON_USEDEP}]' python3_12)
"

BDEPEND="
	dev-python/uv-dynamic-versioning
"

pkg_postinst() {
	optfeature "FastAPI/Starlette HTTP server" \
		"dev-python/fastapi dev-python/sse-starlette"
	optfeature "gRPC server" \
		"dev-python/grpcio dev-python/grpcio-reflection"
	optfeature "SQL-backed task store" \
		"dev-python/sqlalchemy[asyncio] dev-python/alembic"
	optfeature "Encryption" \
		">=dev-python/cryptography-43.0.0"
	optfeature "OpenTelemetry tracing" \
		"dev-python/opentelemetry-api dev-python/opentelemetry-sdk"
}
