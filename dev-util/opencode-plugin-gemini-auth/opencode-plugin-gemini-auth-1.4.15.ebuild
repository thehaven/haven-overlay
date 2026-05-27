# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-gemini-auth"
inherit npm

DESCRIPTION="Authenticate OpenCode with your Google Gemini plan"
HOMEPAGE="https://github.com/jenslys/opencode-gemini-auth"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opencode-ai-plugin
"

pkg_postinst() {
	einfo "OpenCode Gemini Auth plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  \"/usr/$(get_libdir)/node_modules/opencode-gemini-auth/dist/index.js\""
}
