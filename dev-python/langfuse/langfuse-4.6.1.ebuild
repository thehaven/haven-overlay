# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Open source LLM engineering platform"
HOMEPAGE="https://github.com/langfuse/langfuse"
SRC_URI="https://github.com/langfuse/langfuse/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
S="${WORKDIR}/${P}"
KEYWORDS="~amd64"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/tenacity[${PYTHON_USEDEP}]
	dev-python/backoff[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/duckdb[${PYTHON_USEDEP}]
	>=dev-python/opentelemetry-api-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/opentelemetry-sdk-1.15.0[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" -m unittest discover -s tests || die "Tests failed with ${EPYTHON}"
}

pkg_postinst() {
	einfo "Langfuse installed successfully!"
	einfo ""
	einfo "Langfuse is an open source LLM engineering platform that helps you"
	einfo "trace, evaluate, and manage your language model applications."
	einfo ""
	einfo "Features:"
	einfo "  - LLM observability and tracing"
	einfo "  - Evaluation and testing framework"
	einfo "  - Prompt management"
	einfo "  - Analytics and insights"
	einfo "  - OpenTelemetry integration"
	einfo ""
	einfo "To get started:"
	einfo "1. Set up a Langfuse server or use the cloud version"
	einfo "2. Configure your application with the API keys"
	einfo "3. Start tracing your LLM interactions"
	einfo ""
	einfo "For more information, see the project documentation at:"
	einfo "  https://github.com/langfuse/langfuse"
}
