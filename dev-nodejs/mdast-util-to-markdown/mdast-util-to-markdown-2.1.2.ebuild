# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="mdast-util-to-markdown"


DESCRIPTION="mdast utility to serialize markdown"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-to-markdown#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/longest-streak
	dev-nodejs/mdast-util-phrasing
	dev-nodejs/mdast-util-to-string
	dev-nodejs/micromark-util-classify-character
	dev-nodejs/micromark-util-decode-string
	dev-nodejs/types-mdast
	dev-nodejs/types-unist
	dev-nodejs/unist-util-visit
	dev-nodejs/zwitch
"
BDEPEND=""
