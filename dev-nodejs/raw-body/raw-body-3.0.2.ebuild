# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="raw-body"
inherit npm

DESCRIPTION="Get and validate the raw body of a readable stream."
HOMEPAGE="https://github.com/stream-utils/raw-body#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/bytes
	dev-nodejs/http-errors
	dev-nodejs/iconv-lite
	dev-nodejs/unpipe
"
BDEPEND="${RDEPEND}"
