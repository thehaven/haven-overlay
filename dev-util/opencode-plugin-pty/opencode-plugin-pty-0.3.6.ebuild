# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="opencode-pty"

DESCRIPTION="OpenCode PTY plugin for live interactive pseudoterminals"
HOMEPAGE="https://github.com/shekohex/opencode-pty"
SRC_URI="https://registry.npmjs.org/${NPM_PKG}/-/${NPM_PKG}-${PV}.tgz -> ${P}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox"

BDEPEND="net-libs/nodejs[npm]"
RDEPEND="net-libs/nodejs"

src_compile() { :; }

src_install() {
	npm install --audit false --global --omit dev \
		--prefix "${ED}/usr" "${DISTDIR}/${P}.tgz" || die

	# Smoke test: verify runtime deps installed (catches extract-only
	# ebuilds that skip npm install and ship zero deps — the original
	# "Cannot find package 'open'" error)
	local depdir="${ED}/usr/$(get_libdir)/node_modules/${NPM_PKG}/node_modules"
	for dep in open bun-pty @opencode-ai/sdk @opencode-ai/plugin; do
		[[ -d "${depdir}/${dep}" ]] || \
			die "Plugin ${NPM_PKG} missing dep: ${dep}"
	done
}

pkg_postinst() {
	einfo "OpenCode PTY plugin installed."
	einfo "To use this plugin, add to your opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/${NPM_PKG}/dist/index.js\""
}
