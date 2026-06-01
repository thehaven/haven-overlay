# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="find-packages"


DESCRIPTION="Find all packages inside a directory"
HOMEPAGE="https://www.npmjs.com/package/find-packages"
HOMEPAGE="https://www.npmjs.com/package/find-packages"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fast-glob
	dev-nodejs/p-filter
	dev-nodejs/pnpm-read-project-manifest
	dev-nodejs/pnpm-types
	dev-nodejs/pnpm-util-lex-comparator
"
BDEPEND=""
