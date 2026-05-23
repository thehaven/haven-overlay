# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@pnpm/graceful-fs"


DESCRIPTION="Promisified graceful-fs"
HOMEPAGE="https://github.com/pnpm/pnpm/tree/main/fs/graceful-fs#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/graceful-fs
"
BDEPEND=""
