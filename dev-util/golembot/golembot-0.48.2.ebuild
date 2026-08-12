# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="golembot"

DESCRIPTION="AI Coding Agent gateway for Slack, Telegram, Discord, Feishu and more"
HOMEPAGE="https://github.com/0xranx/golembot"
SRC_URI="https://registry.npmjs.org/${NPM_MODULE}/-/${NPM_MODULE}-${PV}.tgz -> ${P}.tgz"
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

	# Smoke test: verify the bin symlink exists and its target is executable
	# (replaces the broken custom npm_src_install that did `doins -r
	# node_modules` — the npm distfile ships no node_modules)
	local bindir="${ED}/usr/bin"
	[[ -L "${bindir}/golembot" ]] || \
		die "npm install did not create /usr/bin/golembot"
	[[ -x $(realpath "${bindir}/golembot") ]] || \
		die "/usr/bin/golembot target is not executable"
}

pkg_postinst() {
	einfo "GolemBot installed. Run 'golembot onboard' for guided setup."
}
