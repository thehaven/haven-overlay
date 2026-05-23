# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="which"


DESCRIPTION="Like which(1) unix command. Find the first instance of an executable in the PATH."
HOMEPAGE="https://github.com/npm/node-which#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/isexe
"
BDEPEND=""
