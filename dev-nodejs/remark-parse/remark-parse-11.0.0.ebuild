# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="remark-parse"


DESCRIPTION="remark plugin to add support for parsing markdown input"
HOMEPAGE="https://remark.js.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mdast-util-from-markdown
	dev-nodejs/micromark-util-types
	dev-nodejs/types-mdast
	dev-nodejs/unified
"
BDEPEND=""
