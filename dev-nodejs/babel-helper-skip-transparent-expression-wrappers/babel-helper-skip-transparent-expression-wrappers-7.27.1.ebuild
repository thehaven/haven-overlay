# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-skip-transparent-expression-wrappers"
inherit npm

DESCRIPTION="Helper which skips types and parentheses"
HOMEPAGE="https://www.npmjs.com/package/@babel/helper-skip-transparent-expression-wrappers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-traverse
	dev-nodejs/babel-types
"
BDEPEND="${RDEPEND}"
