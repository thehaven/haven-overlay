# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Strike Freedom Cockpit Plugin"
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
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/strike_freedom_cockpit"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Strike Freedom Cockpit plugin installed successfully!"
	einfo ""
	einfo "This plugin provides an advanced cockpit interface for Hermes Agent"
	einfo "with enhanced control and monitoring capabilities."
	einfo ""
	einfo "Features:"
	einfo "  - Advanced web-based cockpit interface"
	einfo "  - Real-time system monitoring"
	einfo "  - Enhanced control capabilities"
	einfo "  - Customizable dashboard"
	einfo ""
	einfo "To use the Strike Freedom Cockpit plugin:"
	einfo "1. Configure web server settings"
	einfo "2. Set up authentication and access controls"
	einfo "3. Enable the plugin in Hermes configuration"
	einfo "4. Access the cockpit through your web browser"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
