# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="formdata-polyfill"
inherit npm

DESCRIPTION="HTML5 \`FormData\` for Browsers and Node."
HOMEPAGE="https://github.com/jimmywarting/FormData#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fetch-blob
"
BDEPEND="${RDEPEND}"
