# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="cli-truncate"
inherit npm

DESCRIPTION="Truncate a string to a specific width in the terminal"
HOMEPAGE="https://github.com/sindresorhus/cli-truncate#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/slice-ansi
	dev-nodejs/string-width
"
BDEPEND="${RDEPEND}"
