# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode PTY plugin for live interactive pseudoterminals"
HOMEPAGE="https://github.com/shekohex/opencode-pty"
SRC_URI="https://registry.npmjs.org/opencode-pty/-/opencode-pty-0.3.6.tgz "
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "opencode-plugin-pty installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\""
}
