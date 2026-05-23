# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@babel/runtime-corejs3"

inherit npm

DESCRIPTION="babel's modular runtime helpers with core-js@3 polyfilling"
HOMEPAGE="https://www.npmjs.com/package/@babel/runtime-corejs3"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/core-js-pure
"
BDEPEND=""
