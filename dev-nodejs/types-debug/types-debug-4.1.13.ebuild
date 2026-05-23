# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@types/debug"

inherit npm

DESCRIPTION="TypeScript definitions for debug"
HOMEPAGE="https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/debug"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-ms
"
BDEPEND="${RDEPEND}"
