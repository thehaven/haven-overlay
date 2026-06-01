# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="cliui"
inherit npm

DESCRIPTION="easily create complex multi-column command-line-interfaces"
HOMEPAGE="https://github.com/yargs/cliui#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/string-width
	dev-nodejs/strip-ansi
	dev-nodejs/wrap-ansi
"
BDEPEND="${RDEPEND}"
