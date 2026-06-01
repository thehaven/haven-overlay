# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="vfile"


DESCRIPTION="Virtual file format for text processing"
HOMEPAGE="https://github.com/vfile/vfile#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/types-unist
	dev-nodejs/vfile-message
"
BDEPEND=""
