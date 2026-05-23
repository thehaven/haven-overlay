# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="cacheable-request"

inherit npm

DESCRIPTION="Wrap native HTTP requests with RFC compliant cache support"
HOMEPAGE="https://github.com/jaredwray/cacheable#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/get-stream
	dev-nodejs/http-cache-semantics
	dev-nodejs/keyv
	dev-nodejs/mimic-response
	dev-nodejs/normalize-url
	dev-nodejs/responselike
	dev-nodejs/types-http-cache-semantics
"
BDEPEND="${RDEPEND}"
