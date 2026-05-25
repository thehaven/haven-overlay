# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/preset-typescript"
inherit npm

DESCRIPTION="Babel preset for TypeScript."
HOMEPAGE="https://babel.dev/docs/en/next/babel-preset-typescript"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-plugin-utils
	dev-nodejs/babel-helper-validator-option
	dev-nodejs/babel-plugin-syntax-jsx
	dev-nodejs/babel-plugin-transform-modules-commonjs
	dev-nodejs/babel-plugin-transform-typescript
"
BDEPEND="${RDEPEND}"
