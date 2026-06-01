# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="saxes"
inherit npm

DESCRIPTION="An evented streaming XML parser in JavaScript"
HOMEPAGE="https://github.com/lddubeau/saxes#readme"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/xmlchars
"
BDEPEND="${RDEPEND}"
