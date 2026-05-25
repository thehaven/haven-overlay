# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Morph Fast Apply plugin — 10,500+ tokens/sec code editing for OpenCode"
HOMEPAGE="https://github.com/JRedeker/opencode-morph-fast-apply"
SRC_URI="https://github.com/JRedeker/opencode-morph-fast-apply/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/diff
"

S="${WORKDIR}/opencode-morph-fast-apply-${PV}"

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r src package.json tsconfig.json
}

pkg_postinst() {
	einfo "OpenCode Morph Fast Apply plugin installed."
	einfo "Requires MORPH_API_KEY environment variable."
	einfo "To enable, add to opencode.json:"
	einfo "  { \"name\": \"opencode-morph-fast-apply\","
	einfo "    \"src\": \"/usr/lib/node_modules/opencode-plugin-morph-fast-apply/src/index.ts\" }"
}
