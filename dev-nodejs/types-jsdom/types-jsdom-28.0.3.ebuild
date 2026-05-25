# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@types/jsdom"
inherit npm

DESCRIPTION="TypeScript definitions for jsdom"
HOMEPAGE="https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/jsdom"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/parse5
	dev-nodejs/types-node
	dev-nodejs/types-tough-cookie
	dev-nodejs/undici-types
"
BDEPEND="${RDEPEND}"
