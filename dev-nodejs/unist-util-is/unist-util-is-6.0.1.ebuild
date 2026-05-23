# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="unist-util-is"
inherit npm

DESCRIPTION="unist utility to check if a node passes a test"
HOMEPAGE="https://github.com/syntax-tree/unist-util-is#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-unist
"
BDEPEND="${RDEPEND}"
