# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for rate-limiting destructive tool calls"
HOMEPAGE="https://github.com/inkdust2021/opencode-vibeguard"
SRC_URI="https://github.com/inkdust2021/opencode-vibeguard/archive/refs/heads/master.tar.gz -> opencode-vibeguard-main.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/opencode-vibeguard-main"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r src package.json
}

pkg_postinst() {
	einfo "opencode-vibeguard ${PV} installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/src/index.js\""
}
