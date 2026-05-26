# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Google Antigravity IDE OAuth auth plugin for OpenCode"
HOMEPAGE="https://github.com/NoeFabris/opencode-antigravity-auth"
SRC_URI="https://github.com/NoeFabris/opencode-antigravity-auth/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

BDEPEND="|| ( dev-lang/bun-bin dev-lang/bun )"
RDEPEND="dev-util/opencode"

S="${WORKDIR}/opencode-antigravity-auth-${PV}"

src_compile() {
	einfo "Installing dependencies..."
	bun install --ignore-scripts || die

	einfo "Building plugin..."
	bun run build || die
}

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json index.ts src

	exeinto /usr/lib/node_modules/${PN}/dist
	doexe "${FILESDIR}/wrapper.js"
}

pkg_postinst() {
	einfo "opencode-antigravity-auth installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/lib/node_modules/${PN}/dist/wrapper.js\""
}
