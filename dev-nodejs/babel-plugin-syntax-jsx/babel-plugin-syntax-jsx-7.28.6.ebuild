# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/plugin-syntax-jsx"
inherit npm

DESCRIPTION="Allow parsing of jsx"
HOMEPAGE="https://babel.dev/docs/en/next/babel-plugin-syntax-jsx"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-plugin-utils
"
BDEPEND="${RDEPEND}"
