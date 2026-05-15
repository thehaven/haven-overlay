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

src_compile() {
	ego mod tidy
	ego build -o mcp-grafana ./cmd/mcp-grafana
}

src_install() {
	dobin mcp-grafana
	einstalldocs
}
