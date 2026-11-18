# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="MCP server for MediaWiki"
HOMEPAGE="https://github.com/olgasafonova/mediawiki-mcp-server"
SRC_URI="https://github.com/olgasafonova/mediawiki-mcp-server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Revision bump only: rebuild so the recorded dev-lang/go subslot matches the
# current toolchain. The previous build recorded
# >=dev-lang/go-1.24.11:0/1.27.3= (the go-module.eclass-injected BDEPEND),
# which pins a second Go into slot 0 during a world update.
IUSE="cli"
RESTRICT="network-sandbox"
RDEPEND="app-text/poppler[utils]"

src_compile() {
	ego build -ldflags "-s -w" -o mediawiki-mcp-server .

	if use cli; then
		ego build -ldflags "-s -w" -o wiki ./cmd/wiki
	fi
}

src_install() {
	dobin mediawiki-mcp-server
	use cli && dobin wiki
	einstalldocs
}


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mediawiki-mcp-server\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mediawiki-mcp-server\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/mediawiki-mcp-server\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
