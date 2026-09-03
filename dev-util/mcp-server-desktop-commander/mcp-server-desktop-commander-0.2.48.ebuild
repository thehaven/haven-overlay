# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MCP server for desktop automation"
HOMEPAGE="https://github.com/wonderwhy-er/DesktopCommanderMCP"
SRC_URI="https://registry.npmjs.org/@wonderwhy-er/desktop-commander/-/desktop-commander-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=net-libs/nodejs-20[npm]"
python_test() {
	# Generic MCP import check
	${EPYTHON} -c "import mcp; print('Import successful')" || die "Import test failed"
}

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
	elog "      \"command\": \"/usr/bin/desktop-commander\","
	elog "      \"args\": [\"--no-onboarding\"]"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/desktop-commander\","
	elog "      \"args\": [\"--no-onboarding\"]"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/desktop-commander\", \"--no-onboarding\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
