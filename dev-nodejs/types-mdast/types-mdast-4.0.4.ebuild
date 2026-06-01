# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@types/mdast"


DESCRIPTION="TypeScript definitions for mdast"
HOMEPAGE="https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/mdast"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-unist
"
BDEPEND=""
