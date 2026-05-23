# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@yarnpkg/fslib"


DESCRIPTION="Node.js module"
HOMEPAGE="https://www.npmjs.com/package/@yarnpkg/fslib"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tslib
"
BDEPEND=""
