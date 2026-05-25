# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="slice-ansi"
inherit npm

DESCRIPTION="Slice a string with ANSI escape codes"
HOMEPAGE="https://github.com/chalk/slice-ansi#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ansi-styles
	dev-nodejs/is-fullwidth-code-point
"
BDEPEND="${RDEPEND}"
