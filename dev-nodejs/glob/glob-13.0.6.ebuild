# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="glob"


DESCRIPTION="the most correct and second fastest glob implementation in JavaScript"
HOMEPAGE="https://github.com/isaacs/node-glob#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/minimatch
	dev-nodejs/minipass
	dev-nodejs/path-scurry
"
BDEPEND=""
