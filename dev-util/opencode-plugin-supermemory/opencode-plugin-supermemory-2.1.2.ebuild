# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin for Supermemory vector stores"
HOMEPAGE="https://github.com/supermemoryai/opencode-supermemory"
SRC_URI="https://registry.npmjs.org/opencode-supermemory/-/opencode-supermemory-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=net-libs/nodejs-20"

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
	printf '%s\n' \
		'export * from "./dist/server.js";' \
		'export { default } from "./dist/server.js";' \
		> "${T}/server.js" || die
	doins "${T}/server.js"
	printf '\nexport { default } from "./server.js";\n' \
		>> "${ED}/usr/$(get_libdir)/node_modules/${PN}/dist/index.js" || die
	dosym ${PN} /usr/$(get_libdir)/node_modules/opencode-supermemory
}

pkg_postinst() {
	einfo "opencode-plugin-supermemory installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\""
}
