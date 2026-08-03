# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

# openworker is the upstream repo name; the PyPI / install package is
# "coworker". The pyproject.toml ships version="0.0.0" as a placeholder
# (the project is developed as a moving git checkout), so we override PV
# from the GitHub tag and pin S to the openworker-{PV} extract dir.
MY_PN="openworker"
MY_P="${MY_PN}-${PV}"

inherit distutils-r1 optfeature

DESCRIPTION="Agent coworker platform — provider-agnostic agentic coworker runtime"
HOMEPAGE="
	https://github.com/andrewyng/openworker
	https://pypi.org/project/coworker/
"
SRC_URI="https://github.com/andrewyng/${MY_PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="messaging browser bedrock test"
RESTRICT="!test? ( test )"

# Core runtime deps from upstream pyproject.toml.
# Git-pinned aisuite is satisfied by dev-python/aisuite-0.1.14_p20260721
# (overlay ebuild that pins to the same commit). The exact-version
# `=...-r0` form is required by pkgcheck (MissingPackageRevision).
RDEPEND="
	>=dev-python/openai-1.0[${PYTHON_USEDEP}]
	>=dev-python/anthropic-0.40[${PYTHON_USEDEP}]
	>=dev-python/google-genai-1.0[${PYTHON_USEDEP}]
	>=dev-python/google-auth-2.23[${PYTHON_USEDEP}]
	>=dev-python/textual-1.0[${PYTHON_USEDEP}]
	>=dev-python/fastapi-0.110[${PYTHON_USEDEP}]
	>=dev-python/uvicorn-0.27[${PYTHON_USEDEP}]
	=dev-python/aisuite-0.1.14_p20260721-r0[${PYTHON_USEDEP}]
	dev-python/docstring-parser[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2[${PYTHON_USEDEP}]
	<dev-python/mcp-2[${PYTHON_USEDEP}]
	>=dev-python/mcp-1.1[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	>=dev-python/websockets-13[${PYTHON_USEDEP}]
	>=dev-python/ddgs-9[${PYTHON_USEDEP}]
	>=dev-python/croniter-2[${PYTHON_USEDEP}]
	>=dev-python/pypdf-5[${PYTHON_USEDEP}]
	>=dev-python/pypdfium2-4[${PYTHON_USEDEP}]
	messaging? (
		>=dev-python/python-telegram-bot-21[${PYTHON_USEDEP}]
		>=dev-python/slack-bolt-1.18[${PYTHON_USEDEP}]
		>=dev-python/aiohttp-3.9[${PYTHON_USEDEP}]
	)
	browser? (
		>=dev-python/playwright-1.44[${PYTHON_USEDEP}]
	)
	bedrock? (
		>=dev-python/boto3-1.34[${PYTHON_USEDEP}]
	)
"

BDEPEND="
	>=dev-python/setuptools-68
	test? (
		>=dev-python/pytest-8[${PYTHON_USEDEP}]
		>=dev-python/pytest-asyncio-0[${PYTHON_USEDEP}]
		dev-python/httpx[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-asyncio )
distutils_enable_tests pytest

# Upstream pyproject.toml ships version="0.0.0"; supply PV from the
# github tag so distutils records the correct version metadata.
src_prepare() {
	distutils-r1_src_prepare
	sed -i "s/^version = \"0\\.0\\.0\"/version = \"${PV}\"/" pyproject.toml || die
}

pkg_postinst() {
	optfeature "AWS Bedrock provider" "dev-python/boto3"
	optfeature "Interactive browser automation" "dev-python/playwright"
	optfeature "Inbound messaging listeners (Telegram / Slack)" \
		"dev-python/python-telegram-bot dev-python/slack-bolt dev-python/aiohttp"
	elog "Run the server with:    openworker-server"
	elog "Run the CLI with:       openworker"
	elog "Manage connectors with: openworker-connectors"
}
