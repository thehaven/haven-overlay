# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@yarnpkg/parsers"


DESCRIPTION="Node.js module"
HOMEPAGE="https://www.npmjs.com/package/@yarnpkg/parsers"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/js-yaml
	dev-nodejs/tslib
"
BDEPEND=""
