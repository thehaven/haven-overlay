# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="find-packages"

inherit npm

DESCRIPTION="Find all packages inside a directory"
HOMEPAGE="https://github.com/pnpm/pnpm/blob/main/fs/find-packages#readme"

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
BDEPEND="${RDEPEND}"
