# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="wrap-ansi"
inherit npm

DESCRIPTION="Wordwrap a string with ANSI escape codes"
HOMEPAGE="https://github.com/chalk/wrap-ansi#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ansi-styles
	dev-nodejs/string-width
	dev-nodejs/strip-ansi
"
BDEPEND="${RDEPEND}"
