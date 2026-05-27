# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Model Context Protocol server for Slack"
HOMEPAGE="https://github.com/modelcontextprotocol/servers"
SRC_URI="https://github.com/modelcontextprotocol/servers/archive/refs/heads/main.tar.gz -> mcp-servers-main.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/servers-main"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	# Slack is now in the official repo? Let's check.
}

src_install() {
	# Find slack in src/ or wherever it is
	if [[ -d src/slack ]]; then
		cd src/slack || die
		insinto /usr/$(get_libdir)/node_modules/${PN}
		doins -r dist package.json
	fi
}


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-server-slack\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-server-slack\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/mcp-server-slack\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
