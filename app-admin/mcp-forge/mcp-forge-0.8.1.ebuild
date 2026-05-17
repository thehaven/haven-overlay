# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 git-r3

DESCRIPTION="Universal MCP package manager and profile orchestrator"
HOMEPAGE="https://github.com/haven/mcp-forge"
EGIT_REPO_URI="file:///storage/home/haven/projects/personal/mcp-forge"
EGIT_COMMIT="v0.8.1"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

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
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-forge\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-forge\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/mcp-forge\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
