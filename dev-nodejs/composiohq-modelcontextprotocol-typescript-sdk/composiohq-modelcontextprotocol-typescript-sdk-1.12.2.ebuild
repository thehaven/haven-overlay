# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="composiohq-modelcontextprotocol-typescript-sdk"
inherit npm

DESCRIPTION="Model Context Protocol implementation for TypeScript"
HOMEPAGE="https://modelcontextprotocol.io"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ajv
	dev-nodejs/content-type
	dev-nodejs/cors
	dev-nodejs/cross-spawn
	dev-nodejs/eventsource
	dev-nodejs/express
	dev-nodejs/express-rate-limit
	dev-nodejs/pkce-challenge
	dev-nodejs/raw-body
	dev-nodejs/zod
	dev-nodejs/zod-to-json-schema
"
BDEPEND="${RDEPEND}"
