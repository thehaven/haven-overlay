# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@yarnpkg/core"
inherit npm

DESCRIPTION="Node.js module"
HOMEPAGE="https://www.npmjs.com/package/@yarnpkg/core"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/arcanis-slice-ansi
	dev-nodejs/camelcase
	dev-nodejs/chalk
	dev-nodejs/ci-info
	dev-nodejs/clipanion
	dev-nodejs/cross-spawn
	dev-nodejs/diff
	dev-nodejs/dotenv
	dev-nodejs/es-toolkit
	dev-nodejs/fast-glob
	dev-nodejs/got
	dev-nodejs/hpagent
	dev-nodejs/micromatch
	dev-nodejs/p-limit
	dev-nodejs/semver
	dev-nodejs/strip-ansi
	dev-nodejs/tar
	dev-nodejs/tinylogic
	dev-nodejs/treeify
	dev-nodejs/tslib
	dev-nodejs/types-semver
	dev-nodejs/types-treeify
	dev-nodejs/yarnpkg-fslib
	dev-nodejs/yarnpkg-libzip
	dev-nodejs/yarnpkg-parsers
	dev-nodejs/yarnpkg-shell
"
BDEPEND="${RDEPEND}"
