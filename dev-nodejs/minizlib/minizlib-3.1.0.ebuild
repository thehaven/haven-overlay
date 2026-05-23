# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="minizlib"


DESCRIPTION="A small fast zlib stream built on [minipass](http://npm.im/minipass) and Node.js's zlib binding."
HOMEPAGE="https://github.com/isaacs/minizlib#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/minipass
"
BDEPEND=""
