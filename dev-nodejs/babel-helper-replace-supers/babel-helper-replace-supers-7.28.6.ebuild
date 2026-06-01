# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-replace-supers"
inherit npm

DESCRIPTION="Helper function to replace supers"
HOMEPAGE="https://babel.dev/docs/en/next/babel-helper-replace-supers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-member-expression-to-functions
	dev-nodejs/babel-helper-optimise-call-expression
	dev-nodejs/babel-traverse
"
BDEPEND="${RDEPEND}"
