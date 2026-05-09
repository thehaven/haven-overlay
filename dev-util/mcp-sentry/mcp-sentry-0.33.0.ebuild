# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Official Sentry MCP server"
HOMEPAGE="https://github.com/getsentry/mcp-server"
SRC_URI="https://github.com/getsentry/mcp-server/archive/refs/heads/main.tar.gz -> mcp-sentry-main.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/mcp-server-main"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building server..."
	bun run build || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
}
