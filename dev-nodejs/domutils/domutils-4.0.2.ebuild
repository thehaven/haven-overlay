# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="domutils"
inherit npm

DESCRIPTION="Utilities for working with htmlparser2's dom"
HOMEPAGE="https://github.com/fb55/domutils#readme"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/dom-serializer
	dev-nodejs/domelementtype
	dev-nodejs/domhandler
"
BDEPEND="${RDEPEND}"
