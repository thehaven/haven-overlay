# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="babel-preset-solid"
inherit npm

DESCRIPTION="Babel preset to transform JSX for Solid.js"
HOMEPAGE="https://github.com/solidjs/solid/blob/main/packages/babel-preset-solid#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-plugin-jsx-dom-expressions
"
BDEPEND="${RDEPEND}"
