# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/plugin-syntax-typescript"
inherit npm

DESCRIPTION="Allow parsing of TypeScript syntax"
HOMEPAGE="https://babel.dev/docs/en/next/babel-plugin-syntax-typescript"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-plugin-utils
"
BDEPEND="${RDEPEND}"
