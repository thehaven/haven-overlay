# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode tool-interceptor plugin for secret protection"
HOMEPAGE="https://github.com/boxpositron/envsitter-guard"
SRC_URI="https://registry.npmjs.org/envsitter-guard/-/envsitter-guard-0.1.1.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND=">=net-libs/nodejs-20"

src_compile() {
	npm install --omit=dev --audit=false --ignore-scripts || die "npm install failed"
}

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json node_modules
	printf '%s\n' \
		'export * from "./dist/index.js";' \
		'export { default } from "./dist/index.js";' \
		> "${T}/server.js" || die
	doins "${T}/server.js"
	sed -i \
		-e '/"exports": {/a \    "./server": {\n      "types": "./dist/index.d.ts",\n      "default": "./dist/index.js"\n    },' \
		"${ED}/usr/$(get_libdir)/node_modules/${PN}/package.json" || die "failed to patch package.json exports"
}

pkg_postinst() {
	einfo "opencode-plugin-envsitter-guard installed."
	einfo "To use this plugin, add it to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${PN}/dist/index.js\""
}
