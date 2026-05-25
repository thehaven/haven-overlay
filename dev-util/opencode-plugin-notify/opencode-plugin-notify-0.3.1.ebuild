# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="opencode-notify"
inherit npm

DESCRIPTION="Native OS notifications for OpenCode — know when tasks complete"
HOMEPAGE="https://github.com/kdcokenny/opencode-notify"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/opencode-ai-plugin
	dev-nodejs/opencode-ai-sdk
"

pkg_postinst() {
	einfo "OpenCode Notify plugin installed."
	einfo "To enable, add to opencode.json:"
	einfo "  { \"name\": \"opencode-notify\","
	einfo "    \"src\": \"/usr/lib/node_modules/opencode-notify/dist/index.js\" }"
}
