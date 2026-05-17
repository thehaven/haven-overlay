# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Disk Cleanup Plugin"
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
	dev-python/psutil[${PYTHON_USEDEP}]
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/disk_cleanup"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Disk Cleanup plugin installed successfully!"
	einfo ""
	einfo "This plugin provides automated disk cleanup and storage management"
	einfo "capabilities for Hermes Agent to maintain optimal system performance."
	einfo ""
	einfo "Features:"
	einfo "  - Automatic temporary file cleanup"
	einfo "  - Cache management and optimization"
	einfo "  - Storage usage monitoring"
	einfo "  - Configurable cleanup policies"
	einfo ""
	einfo "To use the disk cleanup plugin:"
	einfo "1. Configure cleanup policies in Hermes settings"
	einfo "2. Enable automatic cleanup schedules"
	einfo "3. Monitor storage usage through Hermes dashboard"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
