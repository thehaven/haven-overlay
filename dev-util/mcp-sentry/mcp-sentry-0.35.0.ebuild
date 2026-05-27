# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@sentry/mcp-server"
inherit npm

DESCRIPTION="Official Sentry MCP server"
HOMEPAGE="https://github.com/getsentry/sentry-mcp-server"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	npm_src_install
	npm_install_bin dist/index.js sentry-mcp
}
