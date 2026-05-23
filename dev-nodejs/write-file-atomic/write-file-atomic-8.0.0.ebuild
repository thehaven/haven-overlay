# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="write-file-atomic"
inherit npm

DESCRIPTION="Write files in an atomic fashion w/configurable ownership"
HOMEPAGE="https://github.com/npm/write-file-atomic"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/signal-exit
"
BDEPEND="${RDEPEND}"
