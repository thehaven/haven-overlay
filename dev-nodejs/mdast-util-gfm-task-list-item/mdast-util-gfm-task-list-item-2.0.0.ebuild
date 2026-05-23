# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="mdast-util-gfm-task-list-item"
inherit npm

DESCRIPTION="mdast extension to parse and serialize GFM task list items"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-gfm-task-list-item#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/devlop
	dev-nodejs/mdast-util-from-markdown
	dev-nodejs/mdast-util-to-markdown
	dev-nodejs/types-mdast
"
BDEPEND="${RDEPEND}"
