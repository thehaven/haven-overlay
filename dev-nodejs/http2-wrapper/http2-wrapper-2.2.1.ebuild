# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="http2-wrapper"


DESCRIPTION="HTTP2 client, just with the familiar \`https\` API"
HOMEPAGE="https://github.com/szmarczak/http2-wrapper#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/quick-lru
	dev-nodejs/resolve-alpn
"
BDEPEND=""
