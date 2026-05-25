# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode tool-interceptor plugin for secret protection"
HOMEPAGE="https://github.com/boxpositron/envsitter-guard"
SRC_URI="https://registry.npmjs.org/envsitter-guard/-/envsitter-guard-0.0.4.tgz "
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "opencode-plugin-envsitter-guard installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/lib/node_modules/${PN}/dist/index.js\""
}
