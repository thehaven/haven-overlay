# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@nodelib/fs.walk"


DESCRIPTION="A library for efficiently walking a directory recursively"
HOMEPAGE="https://www.npmjs.com/package/@nodelib/fs.walk"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/fastq
	dev-nodejs/nodelib-fs-scandir
"
BDEPEND=""
