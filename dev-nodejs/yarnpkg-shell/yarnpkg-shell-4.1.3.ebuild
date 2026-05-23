# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@yarnpkg/shell"

inherit npm

DESCRIPTION="Node.js module"
HOMEPAGE="https://www.npmjs.com/package/@yarnpkg/shell"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/chalk
	dev-nodejs/clipanion
	dev-nodejs/cross-spawn
	dev-nodejs/fast-glob
	dev-nodejs/micromatch
	dev-nodejs/tslib
	dev-nodejs/yarnpkg-fslib
	dev-nodejs/yarnpkg-parsers
"
BDEPEND="${RDEPEND}"
