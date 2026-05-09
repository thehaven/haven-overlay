# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin that prefixes shell commands with snip"
HOMEPAGE="https://github.com/VincentHardouin/opencode-snip"
SRC_URI="https://github.com/VincentHardouin/opencode-snip/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode dev-util/snip"

S="${WORKDIR}/opencode-snip-${PV}"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r .opencode package.json
}

pkg_postinst() {
	einfo "opencode-snip installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/lib/node_modules/${PN}/.opencode/plugins/index.ts\" }"
}
