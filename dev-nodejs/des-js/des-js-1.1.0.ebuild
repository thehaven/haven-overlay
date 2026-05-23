# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="des.js"

inherit npm

DESCRIPTION="DES implementation"
HOMEPAGE="https://github.com/indutny/des.js#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/inherits
	dev-nodejs/minimalistic-assert
"
BDEPEND=""
