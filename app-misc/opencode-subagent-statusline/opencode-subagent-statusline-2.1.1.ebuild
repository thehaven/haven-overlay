# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenCode plugin: subagent session statusline with TUI sidebar"
HOMEPAGE="https://github.com/Joaquinvesapa/sub-agent-statusline"
SRC_URI="https://registry.npmjs.org/opencode-subagent-statusline/-/opencode-subagent-statusline-${PV}.tgz"

# npm tarballs extract to package/
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=net-libs/nodejs-20
"

src_install() {
	insinto /usr/lib/node_modules/${PN}
	doins -r dist package.json

	# Install as an OpenCode TUI plugin
	insinto /usr/share/opencode/plugins/${PN}
	doins dist/tui.js
}

pkg_postinst() {
	elog "OpenCode Subagent Statusline installed."
	elog ""
	elog "TUI plugin: /usr/share/opencode/plugins/opencode-subagent-statusline/tui.js"
	elog "Enable in ~/.config/opencode/tui.json or opentui.yaml"
}
