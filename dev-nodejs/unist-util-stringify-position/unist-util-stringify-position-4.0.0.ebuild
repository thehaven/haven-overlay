# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="unist-util-stringify-position"

inherit npm

DESCRIPTION="unist utility to serialize a node, position, or point as a human readable location"
HOMEPAGE="https://github.com/syntax-tree/unist-util-stringify-position#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-unist
"
BDEPEND=""
