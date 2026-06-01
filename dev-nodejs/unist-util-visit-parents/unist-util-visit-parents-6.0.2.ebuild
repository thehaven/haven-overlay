# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="unist-util-visit-parents"


DESCRIPTION="unist utility to recursively walk over nodes, with ancestral information"
HOMEPAGE="https://github.com/syntax-tree/unist-util-visit-parents#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-unist
	dev-nodejs/unist-util-is
"
BDEPEND=""
