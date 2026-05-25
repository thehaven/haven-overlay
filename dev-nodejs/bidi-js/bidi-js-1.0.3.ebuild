# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="bidi-js"
inherit npm

DESCRIPTION="A JavaScript implementation of the Unicode Bidirectional Algorithm"
HOMEPAGE="https://github.com/lojjic/bidi-js#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/require-from-string
"
BDEPEND="${RDEPEND}"
