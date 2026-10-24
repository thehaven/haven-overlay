# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="MCP server for LinkedIn profile, company, and job scraping"
HOMEPAGE="https://github.com/stickerdaniel/linkedin-mcp-server"
SRC_URI="https://github.com/stickerdaniel/linkedin-mcp-server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox test"
# network-sandbox: patchright downloads Chromium at runtime (~150MB)
# test: requires LinkedIn credentials and browser automation

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
	>=dev-python/fastmcp-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/inquirer-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/patchright-1.40.0[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-1.1.1[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install
	python_scriptinto /usr/bin
	python_doscript "${BUILD_DIR}"/scripts-*/linkedin-mcp-server
	python_doscript "${BUILD_DIR}"/scripts-*/linkedin-scraper-mcp
}

pkg_postinst() {
	elog "LinkedIn MCP server provides two entry points:"
	elog "  linkedin-mcp-server  — primary server"
	elog "  linkedin-scraper-mcp — alias for same server"
	elog ""
	elog "Environment variables (optional):"
	elog "  TIMEOUT          — browser page timeout (default: 5000 ms)"
	elog "  TOOL_TIMEOUT     — per-tool timeout (default: 180 s)"
	elog "  CHROME_PATH      — path to Chrome/Chromium executable"
	elog "  USER_DATA_DIR    — browser profile (default: ~/.linkedin-mcp/profile)"
	elog ""
	elog "First run: login with your LinkedIn credentials:"
	elog "  linkedin-mcp-server --login"
	elog ""
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/linkedin-mcp-server\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/linkedin-mcp-server\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/linkedin-mcp-server\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
