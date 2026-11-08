# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Antigravity CLI status-line HUD plugin"
HOMEPAGE="https://github.com/franksde/agy-hud"
SRC_URI="https://github.com/franksde/agy-hud/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

# GitHub archives extract to <repo>-<tag>
S="${WORKDIR}/agy-hud-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=net-libs/nodejs-18
"

src_install() {
	insinto /usr/lib/${PN}
	doins -r dist plugin.json hooks

	# Thin wrapper for the agy-hud binary
	cat > "${T}/agy-hud" <<-EOF
	#!/bin/sh
	exec node /usr/lib/${PN}/dist/agy-hud.js "\$@"
	EOF
	dobin "${T}/agy-hud"
}

pkg_postinst() {
	elog "agy-hud installed to /usr/bin/agy-hud."
	elog ""
	elog "Register with Antigravity:"
	elog "  agy plugin install /usr/lib/agy-hud"
	elog ""
	elog "Config: ~/.config/agy-hud/config.json"
	elog "See https://github.com/franksde/agy-hud for options."
}
