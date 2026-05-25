# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="send"
inherit npm

DESCRIPTION="Better streaming static file server with Range and conditional-GET support"
HOMEPAGE="https://github.com/pillarjs/send#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/debug
	dev-nodejs/encodeurl
	dev-nodejs/escape-html
	dev-nodejs/etag
	dev-nodejs/fresh
	dev-nodejs/http-errors
	dev-nodejs/mime-types
	dev-nodejs/ms
	dev-nodejs/on-finished
	dev-nodejs/range-parser
	dev-nodejs/statuses
"
BDEPEND="${RDEPEND}"
