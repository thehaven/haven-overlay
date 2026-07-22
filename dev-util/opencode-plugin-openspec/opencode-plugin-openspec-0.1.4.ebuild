# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenSpec: spec-driven development plugin for OpenCode"
HOMEPAGE="https://github.com/Octane0411/opencode-plugin-openspec"
SRC_URI="https://registry.npmjs.org/${PN}/-/${PN}-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-util/opencode"

src_install() {
	insinto /usr/$(get_libdir)/node_modules/${PN}
	doins -r dist package.json
}

pkg_postinst() {
	einfo "To enable OpenSpec, add it to your opencode.json plugins array:"
	einfo '  {"plugins": ["opencode-plugin-openspec"]}'
}
