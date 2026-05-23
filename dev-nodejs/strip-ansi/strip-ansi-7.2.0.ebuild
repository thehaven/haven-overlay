# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="strip-ansi"


DESCRIPTION="Strip ANSI escape codes from a string"
HOMEPAGE="https://github.com/chalk/strip-ansi#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ansi-regex
"
BDEPEND=""
