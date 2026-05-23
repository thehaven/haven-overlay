# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="minipass-collect"

inherit npm

DESCRIPTION="A Minipass stream that collects all the data into a single chunk"
HOMEPAGE="https://github.com/isaacs/minipass-collect#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/minipass
"
BDEPEND=""
