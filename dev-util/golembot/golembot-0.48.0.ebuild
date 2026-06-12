# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="golembot"
inherit npm

DESCRIPTION="AI Coding Agent gateway for Slack, Telegram, Discord, Feishu and more"
HOMEPAGE="https://github.com/0xranx/golembot"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

npm_src_install() {
	local libdir=$(get_libdir)
	local module_dir="/usr/${libdir}/node_modules/${NPM_MODULE}"

	insinto "${module_dir}"
	doins -r dist package.json node_modules

	npm_install_bin dist/cli.js golembot
}

pkg_postinst() {
	einfo "GolemBot installed. Run 'golembot onboard' for guided setup."
}
