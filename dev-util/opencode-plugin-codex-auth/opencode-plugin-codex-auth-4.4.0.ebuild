# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-openai-codex-auth"
inherit npm

DESCRIPTION="OpenAI Codex OAuth for OpenCode — ChatGPT Plus/Pro models"
HOMEPAGE="https://github.com/numman-ali/opencode-openai-codex-auth"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/jsonc-parser
"

pkg_postinst() {
	einfo "OpenCode Codex Auth plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  \"/usr/lib/node_modules/opencode-openai-codex-auth/dist/index.js\""
}
