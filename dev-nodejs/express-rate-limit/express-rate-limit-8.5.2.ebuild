# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="express-rate-limit"
inherit npm

DESCRIPTION="Basic IP rate-limiting middleware for Express. Use to limit repeated requests to public APIs and/or endpoints such as password reset."
HOMEPAGE="https://github.com/express-rate-limit/express-rate-limit"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ip-address
"
BDEPEND="${RDEPEND}"
