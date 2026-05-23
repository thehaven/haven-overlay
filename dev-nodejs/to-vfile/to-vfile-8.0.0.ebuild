# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="to-vfile"


DESCRIPTION="vfile utility to read and write to the file system"
HOMEPAGE="https://github.com/vfile/to-vfile#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/vfile
"
BDEPEND=""
