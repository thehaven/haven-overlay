# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="mdast-util-to-string"


DESCRIPTION="mdast utility to get the plain text content of a node"
HOMEPAGE="https://github.com/syntax-tree/mdast-util-to-string#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-mdast
"
BDEPEND=""
