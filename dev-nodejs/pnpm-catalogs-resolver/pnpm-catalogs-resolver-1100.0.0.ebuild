# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@pnpm/catalogs.resolver"


DESCRIPTION="Dereferences catalog protocol specifiers into usable specifiers."
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/catalogs/resolver#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/pnpm-catalogs-protocol-parser
	dev-nodejs/pnpm-error
"
BDEPEND=""
