# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_AUTO_BIN=1
NPM_MODULE="@playwright/mcp"
inherit npm

DESCRIPTION="MCP server for Playwright browser automation"
HOMEPAGE="https://github.com/microsoft/playwright-mcp"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=net-libs/nodejs-20
	>=www-client/google-chrome-148
"

pkg_postinst() {
	einfo "Playwright MCP server installed."
	einfo "Browsers are managed via >=www-client/google-chrome-148."
	einfo ""
	einfo "To add this MCP server to your AI clients:"
	einfo ""
	einfo "  OpenCode (~/.config/opencode/opencode.json):"
	einfo "    \"mcp-server-playwright\": {"
	einfo "      \"type\": \"local\","
	einfo "      \"command\": [\"/usr/bin/playwright-mcp\"],"
	einfo "      \"env\": { \"PLAYWRIGHT_BROWSERS_PATH\": \"/usr/share/playwright-browsers\" },"
	einfo "      \"enabled\": true"
	einfo "    }"
}
