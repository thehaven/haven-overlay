# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Image Generation Plugin"
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
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/image_gen"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Image Generation plugin installed successfully!"
	einfo ""
	einfo "This plugin provides image generation capabilities using various"
	einfo "AI models and services for creating visual content."
	einfo ""
	einfo "Features:"
	einfo "  - Multiple image generation backends"
	einfo "  - Configurable generation parameters"
	einfo "  - Image processing and optimization"
	einfo "  - Batch generation support"
	einfo ""
	einfo "To use the image generation plugin:"
	einfo "1. Configure API keys for your preferred image service"
	einfo "2. Set default generation parameters"
	einfo "3. Enable the plugin in Hermes configuration"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
