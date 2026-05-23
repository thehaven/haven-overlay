# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="mdast-util-gfm-table"

inherit npm

DESCRIPTION="mdast extension to parse and serialize GFM tables"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-gfm-table#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/devlop
	dev-nodejs/markdown-table
	dev-nodejs/mdast-util-from-markdown
	dev-nodejs/mdast-util-to-markdown
	dev-nodejs/types-mdast
"
BDEPEND="${RDEPEND}"
