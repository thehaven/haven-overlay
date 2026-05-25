# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="ansi-escapes"
inherit npm

DESCRIPTION="ANSI escape codes for manipulating the terminal"
HOMEPAGE="https://github.com/sindresorhus/ansi-escapes#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/environment
"
BDEPEND="${RDEPEND}"
