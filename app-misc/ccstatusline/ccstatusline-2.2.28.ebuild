# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Customisable status line formatter for Claude Code CLI"
HOMEPAGE="https://github.com/sirmalloc/ccstatusline"
SRC_URI="https://registry.npmjs.org/ccstatusline/-/ccstatusline-${PV}.tgz"

# npm tarballs extract to package/
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=net-libs/nodejs-14
"

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json

	# Thin wrapper for the CLI entry point
	cat > "${T}/ccstatusline" <<-EOF
	#!/bin/sh
	exec node /usr/lib/node_modules/${PN}/dist/ccstatusline.js "\$@"
	EOF
	dobin "${T}/ccstatusline"
}

pkg_postinst() {
	elog "ccstatusline installed to /usr/bin/ccstatusline."
	elog ""
	elog "Configure Claude Code: add to ~/.claude/settings.json:"
	elog '  "statusLine": { "type": "command", "command": "ccstatusline" }'
}
