# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="extend-shallow"
inherit npm

DESCRIPTION="Extend an object with the properties of additional objects. node.js/javascript util."
HOMEPAGE="https://github.com/jonschlinkert/extend-shallow"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/assign-symbols
	dev-nodejs/is-extendable
"
BDEPEND="${RDEPEND}"
