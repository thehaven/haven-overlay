# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Model Context Protocol server for Postgres"
HOMEPAGE="https://github.com/modelcontextprotocol/servers"
SRC_URI="https://github.com/modelcontextprotocol/servers/archive/refs/heads/main.tar.gz -> mcp-servers-main.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode dev-db/postgresql"

S="${WORKDIR}/servers-main"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building postgres..."
	cd src/postgres || die
	bun run build || die
}

src_install() {
	cd src/postgres || die
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "mcp-postgres installed."
}
