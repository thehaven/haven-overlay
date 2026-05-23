# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="fs-minipass"


DESCRIPTION="fs read and write streams based on minipass"
HOMEPAGE="https://github.com/npm/fs-minipass#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/minipass
"
BDEPEND=""
