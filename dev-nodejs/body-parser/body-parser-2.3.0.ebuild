# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="body-parser"
inherit npm

DESCRIPTION="Node.js body parsing middleware"
HOMEPAGE="https://github.com/expressjs/body-parser#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/bytes
	dev-nodejs/content-type
	dev-nodejs/debug
	dev-nodejs/http-errors
	dev-nodejs/iconv-lite
	dev-nodejs/on-finished
	dev-nodejs/qs
	dev-nodejs/raw-body
	dev-nodejs/type-is
"
BDEPEND="${RDEPEND}"
