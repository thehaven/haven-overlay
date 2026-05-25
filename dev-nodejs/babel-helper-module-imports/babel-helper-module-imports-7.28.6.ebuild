# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helper-module-imports"
inherit npm

DESCRIPTION="Babel helper functions for inserting module loads"
HOMEPAGE="https://babel.dev/docs/en/next/babel-helper-module-imports"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-traverse
	dev-nodejs/babel-types
"
BDEPEND="${RDEPEND}"
