# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="got"

inherit npm

DESCRIPTION="Human-friendly and powerful HTTP request library for Node.js"
HOMEPAGE="https://github.com/sindresorhus/got#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/byte-counter
	dev-nodejs/cacheable-lookup
	dev-nodejs/cacheable-request
	dev-nodejs/chunk-data
	dev-nodejs/decompress-response
	dev-nodejs/http2-wrapper
	dev-nodejs/keyv
	dev-nodejs/lowercase-keys
	dev-nodejs/responselike
	dev-nodejs/sindresorhus-is
	dev-nodejs/type-fest
	dev-nodejs/uint8array-extras
"
BDEPEND="${RDEPEND}"
