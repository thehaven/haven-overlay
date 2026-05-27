# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Official PagerDuty MCP server"
HOMEPAGE="https://github.com/PagerDuty/pagerduty-mcp-server"
SRC_URI="https://github.com/PagerDuty/pagerduty-mcp-server/archive/refs/heads/main.tar.gz -> mcp-pagerduty-main.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/pagerduty-mcp-server-main"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building server..."
	bun run build || die
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
}


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-server-pagerduty\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-server-pagerduty\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/mcp-server-pagerduty\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
