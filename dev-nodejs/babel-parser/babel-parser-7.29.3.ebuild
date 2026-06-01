# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/parser"
inherit npm

DESCRIPTION="A JavaScript parser"
HOMEPAGE="https://babel.dev/docs/en/next/babel-parser"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-types
"
BDEPEND="${RDEPEND}"
