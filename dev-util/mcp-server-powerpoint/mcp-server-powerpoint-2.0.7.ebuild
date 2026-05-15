# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="office-powerpoint-mcp-server"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for PowerPoint"
HOMEPAGE="https://pypi.org/project/office-powerpoint-mcp-server/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/mcp-1.2.0[${PYTHON_USEDEP}]
	dev-python/python-pptx[${PYTHON_USEDEP}]
"

S="${WORKDIR}/office_powerpoint_mcp_server-${PV}"

src_prepare() {
	distutils-r1_src_prepare

	# Fix stray top-level files by creating a proper package structure
	mkdir office_powerpoint_mcp_server || die
	mv tools utils ppt_mcp_server.py slide_layout_templates.json __init__.py office_powerpoint_mcp_server/ || die
	
	# Update pyproject.toml to include the new package and remove conflicting target config
	sed -i 's/only-include = .*/packages = ["office_powerpoint_mcp_server"]/' pyproject.toml || die
	sed -i '/sources = \[/d' pyproject.toml || die

	# Patch imports in the moved files
	sed -i 's/from tools/from office_powerpoint_mcp_server.tools/' office_powerpoint_mcp_server/ppt_mcp_server.py || die
	sed -i 's/from utils/from office_powerpoint_mcp_server.utils/' office_powerpoint_mcp_server/ppt_mcp_server.py || die
}
