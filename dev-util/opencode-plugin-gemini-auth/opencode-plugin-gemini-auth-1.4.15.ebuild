# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="opencode-gemini-auth"

DESCRIPTION="Google Gemini authentication plugin for OpenCode"
HOMEPAGE="https://github.com/jenslys/opencode-gemini-auth"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die
	# Smoke test: plugin entry present with resolved deps
	# (catches the extract-only anti-pattern — deps must come from npm,
	# not bogus dev-nodejs/* atoms)
	local mod="/usr/$(get_libdir)/node_modules/${NPM_PKG}"
	[[ -f "${ED}${mod}/dist/index.js" ]] || die "plugin entry dist/index.js missing"
}
pkg_postinst() {
	einfo "OpenCode Gemini Auth plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  "/usr/$(get_libdir)/node_modules/opencode-gemini-auth/dist/index.js""
}
