# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="babel-plugin-jsx-dom-expressions"
inherit npm

DESCRIPTION="A JSX to DOM plugin that wraps expressions for fine grained change detection"
HOMEPAGE="https://www.npmjs.com/package/babel-plugin-jsx-dom-expressions"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-module-imports
	dev-nodejs/babel-plugin-syntax-jsx
	dev-nodejs/babel-types
	dev-nodejs/html-entities
	dev-nodejs/parse5
"
BDEPEND="${RDEPEND}"
