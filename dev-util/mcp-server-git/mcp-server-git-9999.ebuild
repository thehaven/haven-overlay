# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="MCP server for Git operations"
HOMEPAGE="https://github.com/cyanheads/git-mcp-server"
EGIT_REPO_URI="https://github.com/cyanheads/git-mcp-server.git"

inherit git-r3

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

DEPEND=">=net-libs/nodejs-20"
RDEPEND="${DEPEND}"
BDEPEND=">=net-libs/nodejs-20[npm]"

src_unpack() {
	git-r3_src_unpack
}

src_compile() {
	npm install || die "npm install failed"
	npm run build || die "npm run build failed"
	npm pack || die "npm pack failed"
}

src_install() {
	# Install from the tarball to prevent npm from symlinking to the build directory
	local tarball
	tarball=$(ls -1 *.tgz | head -n 1)
	npm install --global --prefix "${ED}/usr" "${tarball}" || die "npm global install failed"
	einstalldocs
}

pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/git-mcp-server\","
	elog "      \"args\": []"
	elog "    }"
}