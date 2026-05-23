# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@types/yauzl"

inherit npm

DESCRIPTION="TypeScript definitions for yauzl"
HOMEPAGE="https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/types/yauzl"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-node
"
BDEPEND="${RDEPEND}"
