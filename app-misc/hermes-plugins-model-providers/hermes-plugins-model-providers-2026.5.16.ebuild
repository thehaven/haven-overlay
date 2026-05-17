# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Model Providers Plugin"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"
SRC_URI="https://github.com/NousResearch/hermes-agent/archive/refs/tags/v${PV}.tar.gz -> hermes-agent-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
S="${WORKDIR}/hermes-agent-${PV}/plugins/."
KEYWORDS="~amd64"

DEPEND=">=app-misc/hermes-2026.5.16"
RDEPEND="${DEPEND}
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/openai[${PYTHON_USEDEP}]
	dev-python/anthropic[${PYTHON_USEDEP}]
	dev-python/litellm[${PYTHON_USEDEP}]
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/model_providers"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Model Providers plugin installed successfully!"
	einfo ""
	einfo "This plugin provides unified access to multiple AI model providers"
	einfo "including OpenAI, Anthropic, and other LLM services."
	einfo ""
	einfo "Features:"
	einfo "  - Multi-provider model access"
	einfo "  - Unified API interface"
	einfo "  - Model selection and switching"
	einfo "  - Provider-specific optimizations"
	einfo ""
	einfo "To use the model providers plugin:"
	einfo "1. Configure API keys for your preferred providers"
	einfo "2. Set default model preferences"
	einfo "3. Enable the plugin in Hermes configuration"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
