# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="MCP server for Grafana"
HOMEPAGE="https://github.com/grafana/mcp-grafana"
SRC_URI="https://github.com/grafana/mcp-grafana/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.25"

src_unpack() {
	default
}

src_prepare() {
	default
	sed -i 's/^go 1\.26\.[0-9]*/go 1.25/' go.mod || die
}

src_compile() {
	# grafana-plugin-sdk-go@v0.290.1 requires go >= 1.25.7; system go is
	# 1.25.5 and the go-module eclass forces GOTOOLCHAIN=local. Allow Go
	# to auto-fetch a newer toolchain (network-sandbox is unrestricted above).
	export GOTOOLCHAIN="go1.25.7+"
	ego mod tidy
	ego build -o mcp-grafana ./cmd/mcp-grafana
}

src_install() {
	dobin mcp-grafana
	einstalldocs
}


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-grafana\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/mcp-grafana\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/mcp-grafana\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
