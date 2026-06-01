# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/traverse"
inherit npm

DESCRIPTION="The Babel Traverse module maintains the overall tree state, and is responsible for replacing, removing, and adding nodes"
HOMEPAGE="https://babel.dev/docs/en/next/babel-traverse"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-code-frame
	dev-nodejs/babel-generator
	dev-nodejs/babel-helper-globals
	dev-nodejs/babel-parser
	dev-nodejs/babel-template
	dev-nodejs/babel-types
	dev-nodejs/debug
"
BDEPEND="${RDEPEND}"
