# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Official Grafana Labs MCP server for observability"
HOMEPAGE="https://github.com/grafana/mcp-grafana"
SRC_URI="https://github.com/grafana/mcp-grafana/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Use network-sandbox restriction for overlay pragmatism if vendor tarball missing
RESTRICT="network-sandbox test"

src_unpack() {
	default
}

src_compile() {
	# Hack go.mod before build to allow running on slightly older Go
	# and use GOTOOLCHAIN=local+auto to satisfy toolchain requirements
	sed -i 's/go 1.26.1/go 1.25.5/' go.mod || die
	GOTOOLCHAIN=local+auto ego build -o ${PN} ./cmd/${PN}
}

src_install() {
	dobin ${PN}
	einstalldocs
}
