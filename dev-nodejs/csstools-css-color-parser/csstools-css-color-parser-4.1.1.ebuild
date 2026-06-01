# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@csstools/css-color-parser"
inherit npm

DESCRIPTION="Parse CSS color values"
HOMEPAGE="https://github.com/csstools/postcss-plugins/tree/main/packages/css-color-parser#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/csstools-color-helpers
	dev-nodejs/csstools-css-calc
"
BDEPEND="${RDEPEND}"
