# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="office-powerpoint-mcp-server"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for PowerPoint"
HOMEPAGE="https://pypi.org/project/office-powerpoint-mcp-server/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

python_test() {
	# Auto-generated import check
	local mod candidates
	# Normalize PN by replacing - with _
	local norm_pn="${PN//-/_}"
	# Strip mcp-server- and mcp- prefixes
	local suffix="${PN#mcp-server-}"
	suffix="${suffix#mcp-}"
	local norm_suffix="${suffix//-/_}"
	
	candidates=(
		"${norm_pn}"
		"mcp_server_${norm_suffix}"
		"${norm_suffix}"
	)
	
	for mod in "${candidates[@]}"; do
		einfo "Checking import of ${mod}..."
		if ${EPYTHON} -c "import ${mod}" 2>/dev/null; then
			einfo "✅ Import successful: ${mod}"
			return 0
		fi
	done
	die "❌ Import test failed: none of the candidates (${candidates[*]}) could be imported"
}

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


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/ppt_mcp_server\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/ppt_mcp_server\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/ppt_mcp_server\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
