# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@pnpm/core-loggers"


DESCRIPTION="Core loggers of pnpm"
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/core/core-loggers#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/pnpm-types
"
BDEPEND=""
