# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/catalogs.protocol-parser"
inherit npm

DESCRIPTION="Parse catalog protocol specifiers and return the catalog name."
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/catalogs/protocol-parser#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="

"
BDEPEND="${RDEPEND}"
