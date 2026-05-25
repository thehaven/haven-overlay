# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-antigravity-auth"
inherit npm

DESCRIPTION="Google Antigravity models for OpenCode — free Gemini/Anthropic access"
HOMEPAGE="https://github.com/NoeFabris/opencode-antigravity-auth"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/zod
"

pkg_postinst() {
	einfo "OpenCode Antigravity Auth plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  \"/usr/lib/node_modules/opencode-antigravity-auth/dist/index.js\""
}
