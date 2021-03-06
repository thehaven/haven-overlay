# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit npm

DESCRIPTION="Small debugging utility."

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="example"

RDEPEND=">=net-libs/nodejs-0.8.10"
DEPEND=""

NPM_EXTRA_FILES="debug.js component.json"

src_install() {
	npm_src_install

	dodoc Readme* History.md

	if use example; then
		dodoc -r example
	fi
}
