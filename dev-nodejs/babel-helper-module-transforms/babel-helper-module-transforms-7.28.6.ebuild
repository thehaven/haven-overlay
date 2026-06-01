# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-module-transforms"
inherit npm

DESCRIPTION="Babel helper functions for implementing ES6 module transformations"
HOMEPAGE="https://babel.dev/docs/en/next/babel-helper-module-transforms"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-helper-module-imports
	dev-nodejs/babel-helper-validator-identifier
	dev-nodejs/babel-traverse
"
BDEPEND="${RDEPEND}"
