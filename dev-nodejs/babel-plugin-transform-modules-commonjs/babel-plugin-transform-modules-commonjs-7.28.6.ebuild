# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/plugin-transform-modules-commonjs"
inherit npm

DESCRIPTION="This plugin transforms ES2015 modules to CommonJS"
HOMEPAGE="https://babel.dev/docs/en/next/babel-plugin-transform-modules-commonjs"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-module-transforms
	dev-nodejs/babel-helper-plugin-utils
"
BDEPEND="${RDEPEND}"
