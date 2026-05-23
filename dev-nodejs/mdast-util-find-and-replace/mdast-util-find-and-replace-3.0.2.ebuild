# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="mdast-util-find-and-replace"

inherit npm

DESCRIPTION="mdast utility to find and replace text in a tree"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-find-and-replace#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/escape-string-regexp
	dev-nodejs/types-mdast
	dev-nodejs/unist-util-is
	dev-nodejs/unist-util-visit-parents
"
BDEPEND="${RDEPEND}"
