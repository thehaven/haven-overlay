# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Achievements Plugin"
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
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/achievements"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Achievements plugin installed successfully!"
	einfo ""
	einfo "This plugin provides achievement tracking and gamification"
	einfo "features for Hermes Agent interactions."
	einfo ""
	einfo "To use the achievements plugin:"
	einfo "1. Ensure Hermes Agent is properly configured"
	einfo "2. Start Hermes with achievements enabled"
	einfo "3. Track your progress through the achievement system"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
