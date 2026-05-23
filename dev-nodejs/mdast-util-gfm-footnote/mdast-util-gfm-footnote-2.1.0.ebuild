# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="mdast-util-gfm-footnote"

inherit npm

DESCRIPTION="mdast extension to parse and serialize GFM footnotes"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-gfm-footnote#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/devlop
	dev-nodejs/mdast-util-from-markdown
	dev-nodejs/mdast-util-to-markdown
	dev-nodejs/micromark-util-normalize-identifier
	dev-nodejs/types-mdast
"
BDEPEND="${RDEPEND}"
