# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Composio MCP Server"
HOMEPAGE="https://github.com/composiohq/composio"
SRC_URI="https://registry.npmjs.org/@composio/mcp/-/mcp-1.0.9.tgz "

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

S="${WORKDIR}/package"
RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"


src_compile() { :; }

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r .
}

pkg_postinst() {
	einfo "composio-mcp installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/lib/node_modules/${PN}/dist/index.js\" }"
}
