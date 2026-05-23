# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@pnpm/error"

inherit npm

DESCRIPTION="An error class for pnpm errors"
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/core/error#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/pnpm-constants
"
BDEPEND=""
