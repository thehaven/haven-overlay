# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_PKG="opencode-openai-codex-auth"

DESCRIPTION="OpenCode plugin for OpenAI Codex CLI authentication"
HOMEPAGE="https://github.com/numman-ali/opencode-openai-codex-auth"
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
	# Smoke test: bin + plugin entry present (deps resolved by npm)
	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/opencode-openai-codex-auth" ]] || \
		die "/usr/bin/opencode-openai-codex-auth missing"
	[[ -x $(realpath "${bindir}/opencode-openai-codex-auth") ]] || \
		die "codex-auth bin target not executable"
	local mod="/usr/$(get_libdir)/node_modules/${NPM_PKG}"
	[[ -f "${ED}${mod}/dist/index.js" ]] || die "plugin entry dist/index.js missing"
}
pkg_postinst() {
	einfo "OpenCode Codex Auth plugin installed."
	einfo "Binary: /usr/bin/opencode-openai-codex-auth"
	einfo ""
	einfo "To enable in opencode.json:"
	einfo "  "/usr/$(get_libdir)/node_modules/opencode-openai-codex-auth/dist/index.js""
}
