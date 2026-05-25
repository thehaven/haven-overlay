# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/helpers"
inherit npm

DESCRIPTION="Collection of helper functions used by Babel transforms."
HOMEPAGE="https://babel.dev/docs/en/next/babel-helpers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-template
	dev-nodejs/babel-types
"
BDEPEND="${RDEPEND}"
