# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="unist-util-visit"
inherit npm

DESCRIPTION="unist utility to visit nodes"
HOMEPAGE="https://github.com/syntax-tree/unist-util-visit#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-unist
	dev-nodejs/unist-util-is
	dev-nodejs/unist-util-visit-parents
"
BDEPEND="${RDEPEND}"
