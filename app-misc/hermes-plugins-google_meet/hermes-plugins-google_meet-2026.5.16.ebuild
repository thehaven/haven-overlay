# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Google Meet Plugin"
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
	dev-python/google-api-python-client[${PYTHON_USEDEP}]
	dev-python/google-auth[${PYTHON_USEDEP}]
	dev-python/google-auth-oauthlib[${PYTHON_USEDEP}]
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/google_meet"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Google Meet plugin installed successfully!"
	einfo ""
	einfo "This plugin provides integration with Google Meet for meeting"
	einfo "management, transcription, and AI assistant capabilities."
	einfo ""
	einfo "Features:"
	einfo "  - Meeting scheduling and management"
	einfo "  - Real-time transcription"
	einfo "  - Meeting summaries and action items"
	einfo "  - Calendar integration"
	einfo ""
	einfo "To use the Google Meet plugin:"
	einfo "1. Configure Google API credentials"
	einfo "2. Grant necessary permissions for Meet and Calendar access"
	einfo "3. Enable the plugin in Hermes configuration"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
