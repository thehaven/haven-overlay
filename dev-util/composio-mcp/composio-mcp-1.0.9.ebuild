# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@composio/mcp"
inherit npm

DESCRIPTION="MCP CLI tool"
HOMEPAGE="https://www.npmjs.com/package/@composio/mcp"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/abortcontroller-polyfill
	dev-nodejs/chalk
	dev-nodejs/commander
	dev-nodejs/composiohq-modelcontextprotocol-typescript-sdk
	dev-nodejs/event-source-polyfill
	dev-nodejs/event-target-polyfill
	dev-nodejs/js-yaml
	dev-nodejs/rollup-plugin-node-polyfills
	dev-nodejs/types-js-yaml
	dev-nodejs/yargs
	dev-nodejs/zod
"
BDEPEND="${RDEPEND}"
