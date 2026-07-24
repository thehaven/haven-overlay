# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_AUTO_BIN=1
NPM_MODULE="chrome-devtools-mcp"
inherit npm

DESCRIPTION="MCP server for Chrome DevTools Protocol — inspect and interact with Chrome"
HOMEPAGE="https://github.com/ChromeDevTools/chrome-devtools-mcp"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=net-libs/nodejs-20
"
