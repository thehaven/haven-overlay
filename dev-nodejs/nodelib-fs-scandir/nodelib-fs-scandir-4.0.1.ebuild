# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@nodelib/fs.scandir"


DESCRIPTION="List files and directories inside the specified directory"
HOMEPAGE="https://www.npmjs.com/package/@nodelib/fs.scandir"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/nodelib-fs-stat
	dev-nodejs/run-parallel
"
BDEPEND=""
