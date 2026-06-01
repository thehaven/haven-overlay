# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-create-class-features-plugin"
inherit npm

DESCRIPTION="Compile class public and private fields, private methods and decorators to ES6"
HOMEPAGE="https://www.npmjs.com/package/@babel/helper-create-class-features-plugin"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-annotate-as-pure
	dev-nodejs/babel-helper-member-expression-to-functions
	dev-nodejs/babel-helper-optimise-call-expression
	dev-nodejs/babel-helper-replace-supers
	dev-nodejs/babel-helper-skip-transparent-expression-wrappers
	dev-nodejs/babel-traverse
	dev-nodejs/semver
"
BDEPEND="${RDEPEND}"
