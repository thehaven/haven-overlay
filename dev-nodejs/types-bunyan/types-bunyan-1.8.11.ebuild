# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@types/bunyan"


DESCRIPTION="TypeScript definitions for bunyan"
HOMEPAGE="https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/bunyan"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-node
"
BDEPEND=""
