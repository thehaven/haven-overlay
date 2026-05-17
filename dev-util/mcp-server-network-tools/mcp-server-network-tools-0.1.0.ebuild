# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="mcp-nettools"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for network diagnostic tools"
HOMEPAGE="https://github.com/modelcontextprotocol/servers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/dnspython-2.6[${PYTHON_USEDEP}]
	dev-python/mac-vendor-lookup[${PYTHON_USEDEP}]
	>=dev-python/mcp-1.0[${PYTHON_USEDEP}]
	net-analyzer/speedtest-cli[${PYTHON_USEDEP}]
	dev-python/wakeonlan[${PYTHON_USEDEP}]
"


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-nettools\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-nettools\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/mcp-nettools\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
