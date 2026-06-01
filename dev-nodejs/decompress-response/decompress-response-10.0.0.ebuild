# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="decompress-response"


DESCRIPTION="Decompress a HTTP response if needed"
HOMEPAGE="https://github.com/sindresorhus/decompress-response#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mimic-response
"
BDEPEND=""
