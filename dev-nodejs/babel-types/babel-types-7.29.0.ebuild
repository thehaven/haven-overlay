# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/types"
inherit npm

DESCRIPTION="Babel Types is a Lodash-esque utility library for AST nodes"
HOMEPAGE="https://babel.dev/docs/en/next/babel-types"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-string-parser
	dev-nodejs/babel-helper-validator-identifier
"
BDEPEND="${RDEPEND}"
