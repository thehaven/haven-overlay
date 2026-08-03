# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
MY_PN="opencode-a2a"
MY_P="${MY_PN}-${PV}"

# opencode-a2a is the A2A server / client surface for OpenCode. It is
# source-only on GitHub — there is no PyPI release. We pin the GitHub
# release archive at tag v${PV}; setuptools_scm is used to derive the
# version from the git tag (PV here is the upstream tag version).
inherit distutils-r1 optfeature

DESCRIPTION="A2A server / client surface for OpenCode (Apache-2.0)"
HOMEPAGE="https://github.com/Intelligent-Internet/opencode-a2a"
SRC_URI="https://github.com/Intelligent-Internet/${MY_PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

# Core runtime deps from upstream pyproject.toml. Version ranges are
# rendered as >=A,<B pairs (NOT two separate atoms) per Gentoo policy;
# the latter is rejected by pkgcheck (DeprecatedDep).
RDEPEND="
	dev-python/a2a-sdk[${PYTHON_USEDEP}]
	>=dev-python/aiosqlite-0.20[${PYTHON_USEDEP}]
	<dev-python/aiosqlite-1.0[${PYTHON_USEDEP}]
	>=dev-python/fastapi-0.139[${PYTHON_USEDEP}]
	<dev-python/fastapi-1.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27[${PYTHON_USEDEP}]
	<dev-python/httpx-1.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.6[${PYTHON_USEDEP}]
	<dev-python/pydantic-3.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-settings-2.14.2[${PYTHON_USEDEP}]
	<dev-python/pydantic-settings-3.0[${PYTHON_USEDEP}]
	>=dev-python/protobuf-6.33.5[${PYTHON_USEDEP}]
	<dev-python/protobuf-7.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-2.0[${PYTHON_USEDEP}]
	<dev-python/sqlalchemy-3.0[${PYTHON_USEDEP}]
	>=dev-python/sse-starlette-2.1[${PYTHON_USEDEP}]
	<dev-python/sse-starlette-4.0[${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.29[${PYTHON_USEDEP}]
	<dev-python/uvicorn-1.0[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/setuptools-80
	>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-8[${PYTHON_USEDEP}]
<dev-python/pytest-10[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0.23[${PYTHON_USEDEP}]
<dev-python/pytest-asyncio-2.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-7[${PYTHON_USEDEP}]
<dev-python/pytest-cov-8.0.0[${PYTHON_USEDEP}]
	)
"

# Upstream pyproject.toml ships addopts requiring pytest-cov and a
# --cov-fail-under=90 gate. We override addopts and run only smoke tests;
# coverage gating is upstream CI territory.
python_test() {
	${EPYTHON} -m pytest -x -q -o addopts= tests/ || die "Tests failed"
}

pkg_postinst() {
	optfeature "outbound A2A client tracing" \
		"dev-python/opentelemetry-api"
	elog "Configuration: drop a config.toml under /etc/opencode-a2a/."
	elog "Run the server with: opencode-a2a serve /path/to/config.toml"
}
