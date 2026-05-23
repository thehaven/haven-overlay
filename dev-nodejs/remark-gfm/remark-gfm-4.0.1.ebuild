# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="remark-gfm"

inherit npm

DESCRIPTION="remark plugin to support GFM (autolink literals, footnotes, strikethrough, tables, tasklists)"
HOMEPAGE="https://github.com/remarkjs/remark-gfm#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mdast-util-gfm
	dev-nodejs/micromark-extension-gfm
	dev-nodejs/remark-parse
	dev-nodejs/remark-stringify
	dev-nodejs/types-mdast
	dev-nodejs/unified
"
BDEPEND=""
