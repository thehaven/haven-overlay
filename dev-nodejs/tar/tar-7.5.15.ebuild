# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="tar"

inherit npm

DESCRIPTION="tar for node"
HOMEPAGE="https://github.com/isaacs/node-tar#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/chownr
	dev-nodejs/isaacs-fs-minipass
	dev-nodejs/minipass
	dev-nodejs/minizlib
	dev-nodejs/yallist
"
BDEPEND=""
