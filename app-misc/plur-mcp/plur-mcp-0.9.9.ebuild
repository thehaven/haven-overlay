# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PLUR MCP server — persistent memory tools for any AI agent"
HOMEPAGE="https://github.com/plur-ai/plur"
SRC_URI="https://registry.npmjs.org/@plur-ai/mcp/-/mcp-${PV}.tgz -> ${P}.tgz"
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
	elog "To add PLUR MCP to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"plur\": {"
	elog "      \"command\": \"/usr/bin/plur-mcp\","
	elog "      \"args\": [\"stdio\"]"
	elog "    }"
}
