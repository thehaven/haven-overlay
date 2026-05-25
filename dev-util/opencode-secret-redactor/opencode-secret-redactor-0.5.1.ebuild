# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin that redacts secrets from LLM context"
HOMEPAGE="https://github.com/casonadams/opencode-secret-redactor"
SRC_URI="https://registry.npmjs.org/opencode-secret-redactor/-/opencode-secret-redactor-0.5.1.tgz "
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
	einfo "opencode-secret-redactor installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/lib/node_modules/${PN}/dist/plugin.cjs\""
}
