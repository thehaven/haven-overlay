# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@alcalzone/ansi-tokenize"
inherit npm

DESCRIPTION="Efficiently modify strings containing ANSI escape codes"
HOMEPAGE="https://www.npmjs.com/package/@alcalzone/ansi-tokenize"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/ansi-styles
	dev-nodejs/is-fullwidth-code-point
"
BDEPEND="${RDEPEND}"
