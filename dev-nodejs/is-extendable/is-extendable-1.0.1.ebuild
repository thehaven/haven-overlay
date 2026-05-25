# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="is-extendable"
inherit npm

DESCRIPTION="Returns true if a value is a plain object, array or function."
HOMEPAGE="https://github.com/jonschlinkert/is-extendable"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-plain-object
"
BDEPEND="${RDEPEND}"
