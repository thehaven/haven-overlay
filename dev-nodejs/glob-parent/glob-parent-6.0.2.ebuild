# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="glob-parent"


DESCRIPTION="Extract the non-magic parent path from a glob string."
HOMEPAGE="https://github.com/gulpjs/glob-parent#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-glob
"
BDEPEND=""
