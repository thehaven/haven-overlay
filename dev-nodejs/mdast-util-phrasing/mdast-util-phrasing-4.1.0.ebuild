# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="mdast-util-phrasing"


DESCRIPTION="mdast utility to check if a node is phrasing content"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-phrasing#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-mdast
	dev-nodejs/unist-util-is
"
BDEPEND=""
