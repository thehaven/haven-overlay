# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Persistent memory system for AI coding agents"
HOMEPAGE="https://github.com/Gentleman-Programming/engram"
SRC_URI="https://github.com/Gentleman-Programming/engram/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.25"

src_compile() {
	CGO_ENABLED=0 ego build \
		-ldflags "-s -w -X main.version=${PV}" \
		-o engram ./cmd/engram
}

src_install() {
	dobin engram
	einstalldocs
}

pkg_postinst() {
	einfo "To start the MCP server: engram mcp"
	einfo "To launch the TUI: engram tui"
	einfo "To configure your agent: engram setup <agent>"
	einfo "See https://github.com/Gentleman-Programming/engram for docs"
}
