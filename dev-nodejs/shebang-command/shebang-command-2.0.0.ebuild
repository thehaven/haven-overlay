# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="shebang-command"
inherit npm

DESCRIPTION="Get the command from a shebang"
HOMEPAGE="https://github.com/kevva/shebang-command#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/shebang-regex
"
BDEPEND="${RDEPEND}"
