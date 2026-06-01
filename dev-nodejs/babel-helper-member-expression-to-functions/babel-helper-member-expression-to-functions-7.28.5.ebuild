# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-member-expression-to-functions"
inherit npm

DESCRIPTION="Helper function to replace certain member expressions with function calls"
HOMEPAGE="https://babel.dev/docs/en/next/babel-helper-member-expression-to-functions"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-traverse
	dev-nodejs/babel-types
"
BDEPEND="${RDEPEND}"
