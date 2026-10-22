# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Official GitHub MCP server (Go)"
HOMEPAGE="https://github.com/github/github-mcp-server"
SRC_URI="https://github.com/github/github-mcp-server/releases/download/v${PV}/github-mcp-server_Linux_x86_64.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
S="${WORKDIR}"

src_install() {
	dobin github-mcp-server
	einstalldocs
}

pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/github-mcp-server\"],"
	elog "      \"enabled\": true"
	elog "    }"
	elog ""
	elog "Requires GITHUB_PERSONAL_ACCESS_TOKEN in the environment."
}
