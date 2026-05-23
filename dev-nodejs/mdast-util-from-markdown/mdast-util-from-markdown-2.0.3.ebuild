# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="mdast-util-from-markdown"
inherit npm

DESCRIPTION="mdast utility to parse markdown"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-from-markdown#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/decode-named-character-reference
	dev-nodejs/devlop
	dev-nodejs/mdast-util-to-string
	dev-nodejs/micromark
	dev-nodejs/micromark-util-decode-numeric-character-reference
	dev-nodejs/micromark-util-decode-string
	dev-nodejs/micromark-util-normalize-identifier
	dev-nodejs/micromark-util-symbol
	dev-nodejs/micromark-util-types
	dev-nodejs/types-mdast
	dev-nodejs/types-unist
	dev-nodejs/unist-util-stringify-position
"
BDEPEND="${RDEPEND}"
