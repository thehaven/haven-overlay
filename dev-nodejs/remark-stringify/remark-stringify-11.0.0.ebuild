# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="remark-stringify"


DESCRIPTION="remark plugin to add support for serializing markdown"
HOMEPAGE="https://remark.js.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mdast-util-to-markdown
	dev-nodejs/types-mdast
	dev-nodejs/unified
"
BDEPEND=""
