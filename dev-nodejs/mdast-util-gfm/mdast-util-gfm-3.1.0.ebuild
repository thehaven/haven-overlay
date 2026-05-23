# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="mdast-util-gfm"
inherit npm

DESCRIPTION="mdast extension to parse and serialize GFM (GitHub Flavored Markdown)"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-gfm#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mdast-util-from-markdown
	dev-nodejs/mdast-util-gfm-autolink-literal
	dev-nodejs/mdast-util-gfm-footnote
	dev-nodejs/mdast-util-gfm-strikethrough
	dev-nodejs/mdast-util-gfm-table
	dev-nodejs/mdast-util-gfm-task-list-item
	dev-nodejs/mdast-util-to-markdown
"
BDEPEND="${RDEPEND}"
