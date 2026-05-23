# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="handlebars"


DESCRIPTION="Handlebars provides the power necessary to let you build semantic templates effectively with no frustration"
HOMEPAGE="https://handlebarsjs.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/minimist
	dev-nodejs/neo-async
	dev-nodejs/source-map
	dev-nodejs/uglify-js
	dev-nodejs/wordwrap
"
BDEPEND=""
