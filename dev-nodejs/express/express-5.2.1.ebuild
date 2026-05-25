# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="express"
inherit npm

DESCRIPTION="Fast, unopinionated, minimalist web framework"
HOMEPAGE="https://expressjs.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/accepts
	dev-nodejs/body-parser
	dev-nodejs/content-disposition
	dev-nodejs/content-type
	dev-nodejs/cookie
	dev-nodejs/cookie-signature
	dev-nodejs/debug
	dev-nodejs/depd
	dev-nodejs/encodeurl
	dev-nodejs/escape-html
	dev-nodejs/etag
	dev-nodejs/finalhandler
	dev-nodejs/fresh
	dev-nodejs/http-errors
	dev-nodejs/merge-descriptors
	dev-nodejs/mime-types
	dev-nodejs/on-finished
	dev-nodejs/once
	dev-nodejs/parseurl
	dev-nodejs/proxy-addr
	dev-nodejs/qs
	dev-nodejs/range-parser
	dev-nodejs/router
	dev-nodejs/send
	dev-nodejs/serve-static
	dev-nodejs/statuses
	dev-nodejs/type-is
	dev-nodejs/vary
"
BDEPEND="${RDEPEND}"
