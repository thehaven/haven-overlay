# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="mdast-util-gfm-autolink-literal"

inherit npm

DESCRIPTION="mdast extension to parse and serialize GFM autolink literals"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-gfm-autolink-literal#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ccount
	dev-nodejs/devlop
	dev-nodejs/mdast-util-find-and-replace
	dev-nodejs/micromark-util-character
	dev-nodejs/types-mdast
"
BDEPEND=""
