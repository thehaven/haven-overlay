# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="https-proxy-agent"
inherit npm

DESCRIPTION="An HTTP(s) proxy \`http.Agent\` implementation for HTTPS"
HOMEPAGE="https://github.com/TooTallNate/proxy-agents#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/agent-base
	dev-nodejs/debug
"
BDEPEND="${RDEPEND}"
