# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="serve-static"
inherit npm

DESCRIPTION="Serve static files"
HOMEPAGE="https://github.com/expressjs/serve-static#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/encodeurl
	dev-nodejs/escape-html
	dev-nodejs/parseurl
	dev-nodejs/send
"
BDEPEND="${RDEPEND}"
