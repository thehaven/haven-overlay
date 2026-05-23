# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="nth-check"
inherit npm

DESCRIPTION="Parses and compiles CSS nth-checks to highly optimized functions."
HOMEPAGE="https://github.com/fb55/nth-check"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/boolbase
"
BDEPEND="${RDEPEND}"
