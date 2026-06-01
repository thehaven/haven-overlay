# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/template"
inherit npm

DESCRIPTION="Generate an AST from a string template."
HOMEPAGE="https://babel.dev/docs/en/next/babel-template"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-code-frame
	dev-nodejs/babel-parser
	dev-nodejs/babel-types
"
BDEPEND="${RDEPEND}"
