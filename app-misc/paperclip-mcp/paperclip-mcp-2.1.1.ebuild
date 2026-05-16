# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MCP server that exposes the Paperclip REST API as tools"
HOMEPAGE="https://github.com/wizarck/paperclip-mcp"
SRC_URI="https://registry.npmjs.org/paperclip-mcp/-/paperclip-mcp-${PV}.tgz"
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
	elog "To add Paperclip MCP to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"paperclip\": {"
	elog "      \"command\": \"/usr/bin/paperclip-mcp\","
	elog "      \"args\": [\"stdio\"]"
	elog "    }"
}
