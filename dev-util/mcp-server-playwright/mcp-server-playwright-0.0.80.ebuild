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

# npm needs the registry at build time to pull declared deps
RESTRICT="network-sandbox"

RDEPEND="
	>=net-libs/nodejs-20
	>=www-client/google-chrome-148
"

# @playwright/mcp declares exact deps (playwright + playwright-core) that the
# npm eclass does not install; pull them in at build time so cli.js can load.
src_install() {
	npm_src_install
	cd "${S}" || die
	npm install --global --prefix "${ED}/usr" --no-audit --no-fund \
		playwright-core@1.63.0-alpha-2026-08-05 \
		playwright@1.63.0-alpha-2026-08-05 || die
}

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
