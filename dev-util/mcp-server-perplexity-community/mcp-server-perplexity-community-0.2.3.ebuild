# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Community Perplexity MCP server (researcher-mcp)"
HOMEPAGE="https://github.com/dainfernal/researcher-mcp"
SRC_URI="https://registry.npmjs.org/perplexity-mcp/-/perplexity-mcp-${PV}.tgz"
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
	# The official @perplexity-ai/mcp-server also installs /usr/bin/perplexity-mcp;
	# rename ours to avoid a file collision.
	mv "${ED}/usr/bin/perplexity-mcp" "${ED}/usr/bin/perplexity-mcp-community" || die
	einstalldocs
}

pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/perplexity-mcp-community\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
