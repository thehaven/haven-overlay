# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="MCP server for MediaWiki"
HOMEPAGE="https://github.com/olgasafonova/mediawiki-mcp-server"
SRC_URI="https://github.com/olgasafonova/mediawiki-mcp-server/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="cli"
RESTRICT="network-sandbox"
RDEPEND="app-text/poppler[utils]"

src_compile() {
	ego build -ldflags "-s -w" -o mediawiki-mcp-server .

	if use cli; then
		ego build -ldflags "-s -w" -o wiki ./cmd/wiki
	fi
}

src_install() {
	dobin mediawiki-mcp-server
	use cli && dobin wiki
	einstalldocs
}
