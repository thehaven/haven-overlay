# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Kanban Plugin"
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
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/kanban"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Kanban plugin installed successfully!"
	einfo ""
	einfo "This plugin provides Kanban board functionality for task management"
	einfo "and project tracking within Hermes Agent."
	einfo ""
	einfo "Features:"
	einfo "  - Interactive Kanban boards"
	einfo "  - Task tracking and management"
	einfo "  - Workflow automation"
	einfo "  - Project progress visualization"
	einfo ""
	einfo "To use the Kanban plugin:"
	einfo "1. Configure database settings for task persistence"
	einfo "2. Create your first Kanban board"
	einfo "3. Add tasks and track progress"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
