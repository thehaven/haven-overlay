# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for quota tracking"
HOMEPAGE="https://github.com/slkiser/opencode-quota"
SRC_URI="https://registry.npmjs.org/@slkiser/opencode-quota/-/opencode-quota-3.8.7.tgz -> opencode-plugin-quota-3.8.7.tgz"
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
	einfo "opencode-plugin-quota installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  { \"name\": \"${PN}\", \"src\": \"/usr/lib/node_modules/${PN}/dist/index.js\" }"
}
