# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MCP server for Context7 documentation search"
HOMEPAGE="https://github.com/upstash/context7"
SRC_URI="https://registry.npmjs.org/@upstash/context7-mcp/-/context7-mcp-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=net-libs/nodejs-20[npm]"
RDEPEND=">=net-libs/nodejs-20"

src_compile() { :; }

src_install() {
	npm install --global --prefix "${ED}/usr" "${DISTDIR}/${A}" || die
	einstalldocs
}


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/context7-mcp\","
	elog "      \"args\": [\"--api-key\", \"${CONTEXT7_API_KEY}\"]"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/context7-mcp\","
	elog "      \"args\": [\"--api-key\", \"${CONTEXT7_API_KEY}\"]"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/context7-mcp\", \"--api-key\", \"${CONTEXT7_API_KEY}\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
