# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/parse-overrides"

inherit npm

DESCRIPTION="Parse overrides"
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/config/parse-overrides#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/pnpm-catalogs-resolver
	dev-nodejs/pnpm-catalogs-types
	dev-nodejs/pnpm-error
	dev-nodejs/pnpm-parse-wanted-dependency
"
BDEPEND="${RDEPEND}"
