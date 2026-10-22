# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="opencode-antigravity-auth"

DESCRIPTION="Google Antigravity models for OpenCode — free Gemini/Anthropic access"
HOMEPAGE="https://github.com/NoeFabris/opencode-antigravity-auth"
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

	# Smoke test: verify runtime deps installed (catches extract-only
	# ebuilds that skip npm install and ship zero deps — the original
	# "Cannot find module '@openauthjs/openauth/pkce'" error)
	local depdir="${ED}/usr/$(get_libdir)/node_modules/${NPM_PKG}/node_modules"
	for dep in @openauthjs/openauth proper-lockfile xdg-basedir zod; do
		[[ -d "${depdir}/${dep}" ]] || \
			die "Plugin ${NPM_PKG} missing dep: ${dep}"
	done
}

pkg_postinst() {
	einfo "OpenCode Antigravity Auth plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${NPM_PKG}/dist/index.js\""
}
