# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="fast-glob"
inherit npm

DESCRIPTION="It's a very fast and efficient glob library for Node.js"
HOMEPAGE="https://github.com/mrmlnc/fast-glob#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/glob-parent
	dev-nodejs/merge2
	dev-nodejs/micromatch
	dev-nodejs/nodelib-fs-stat
	dev-nodejs/nodelib-fs-walk
"
BDEPEND="${RDEPEND}"
