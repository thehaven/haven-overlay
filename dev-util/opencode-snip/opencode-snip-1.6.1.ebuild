# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-snip"
inherit npm

DESCRIPTION="OpenCode plugin that prefixes shell commands with snip for token reduction"
HOMEPAGE="https://github.com/VincentHardouin/opencode-snip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

pkg_postinst() {
	einfo "opencode-snip installed."
	einfo "To enable, add to opencode.json:"
	einfo "  \"/usr/lib64/node_modules/opencode-snip/.opencode/plugins/index.ts\""
}
