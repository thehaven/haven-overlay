# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for direnv loading"
HOMEPAGE="https://github.com/simonwjackson/opencode-direnv"
SRC_URI="https://registry.npmjs.org/opencode-direnv/-/opencode-direnv-1.1.1.tgz "
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r src package.json
}

pkg_postinst() {
	einfo "opencode-plugin-direnv installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/src/index.ts\""
}
