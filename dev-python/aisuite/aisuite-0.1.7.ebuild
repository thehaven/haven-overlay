# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..15} )

# Pinned to upstream openworker commit 1b4bbf303ec21968230b1ec869a144d054e9b3c4
# via https://github.com/andrewyng/aisuite/commit/1b4bbf3
# Upstream comment: "swap for a PyPI pin once the next aisuite release ships".
AISUITE_COMMIT="1b4bbf303ec21968230b1ec869a144d054e9b3c4"
MY_P="${PN}-${AISUITE_COMMIT}"

inherit distutils-r1 optfeature

DESCRIPTION="Uniform access layer for multiple LLM providers"
HOMEPAGE="https://github.com/andrewyng/aisuite"
SRC_URI="https://github.com/andrewyng/${PN}/archive/${AISUITE_COMMIT}.tar.gz -> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Core (always-on) dependencies from pyproject.toml.
# Optional provider extras are surfaced as optfeature in pkg_postinst;
# upstream gates them with python extras (anthropic, boto3, openai, etc.).
RDEPEND="
	dev-python/docstring-parser[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27.0[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest )
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "Anthropic provider"      dev-python/anthropic
	optfeature "AWS Bedrock provider"    dev-python/boto3
	optfeature "Google Gemini provider"  dev-python/google-genai
	optfeature "OpenAI provider"         dev-python/openai
	optfeature "MCP tooling"             dev-python/mcp
}
