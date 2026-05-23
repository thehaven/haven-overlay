# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="path-scurry"


DESCRIPTION="walk paths fast and efficiently"
HOMEPAGE="https://github.com/isaacs/path-scurry#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/lru-cache
	dev-nodejs/minipass
"
BDEPEND=""
