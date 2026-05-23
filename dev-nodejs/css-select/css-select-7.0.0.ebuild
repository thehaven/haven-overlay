# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="css-select"

inherit npm

DESCRIPTION="a CSS selector compiler/engine"
HOMEPAGE="https://github.com/fb55/css-select#readme"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/boolbase
	dev-nodejs/css-what
	dev-nodejs/domhandler
	dev-nodejs/domutils
	dev-nodejs/nth-check
"
BDEPEND=""
