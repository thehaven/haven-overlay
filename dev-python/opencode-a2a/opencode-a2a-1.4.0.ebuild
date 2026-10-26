# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 optfeature pypi

DESCRIPTION="OpenCode A2A runtime: expose OpenCode through the A2A protocol"
HOMEPAGE="https://github.com/Intelligent-Internet/opencode-a2a"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	=dev-python/a2a-sdk-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/aiosqlite-0.20[${PYTHON_USEDEP}]
	>=dev-python/fastapi-0.139[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.6[${PYTHON_USEDEP}]
	>=dev-python/pydantic-settings-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/protobuf-6.33.5[${PYTHON_USEDEP}]
	<dev-python/protobuf-7[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-2.0[${PYTHON_USEDEP}]
	>=dev-python/sse-starlette-2.1[${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.29[${PYTHON_USEDEP}]
"

pkg_postinst() {
	optfeature "upstream OpenCode server for A2A integration" dev-util/opencode
	optfeature "outbound A2A client tracing" dev-python/opentelemetry-api
	elog "Start an upstream OpenCode server first, e.g.:"
	elog "  opencode serve --hostname 127.0.0.1 --port 4096"
	elog "then run: opencode-a2a serve /path/to/config.toml"
}
