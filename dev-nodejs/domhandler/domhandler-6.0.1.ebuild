# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="domhandler"

inherit npm

DESCRIPTION="Handler for htmlparser2 that turns pages into a dom"
HOMEPAGE="https://github.com/fb55/domhandler#readme"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/domelementtype
"
BDEPEND=""
