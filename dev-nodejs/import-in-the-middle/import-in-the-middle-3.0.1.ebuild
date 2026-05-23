# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="import-in-the-middle"

inherit npm

DESCRIPTION="Intercept imports in Node.js"
HOMEPAGE="https://github.com/nodejs/import-in-the-middle#readme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/acorn
	dev-nodejs/acorn-import-attributes
	dev-nodejs/cjs-module-lexer
	dev-nodejs/module-details-from-path
"
BDEPEND=""
