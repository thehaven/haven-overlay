# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/generator"
inherit npm

DESCRIPTION="Turns an AST into code."
HOMEPAGE="https://babel.dev/docs/en/next/babel-generator"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-parser
	dev-nodejs/babel-types
	dev-nodejs/jridgewell-gen-mapping
	dev-nodejs/jridgewell-trace-mapping
	dev-nodejs/jsesc
"
BDEPEND="${RDEPEND}"
