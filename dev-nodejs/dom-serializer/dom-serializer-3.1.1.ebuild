# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="dom-serializer"

inherit npm

DESCRIPTION="render domhandler DOM nodes to a string"
HOMEPAGE="https://github.com/cheeriojs/dom-serializer#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/domelementtype
	dev-nodejs/domhandler
	dev-nodejs/entities
"
BDEPEND=""
