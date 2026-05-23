# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="minipass-flush"
inherit npm

DESCRIPTION="A Minipass stream that calls a flush function before emitting 'end'"
HOMEPAGE="https://github.com/isaacs/minipass-flush#readme"

LICENSE="unknown"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/minipass
"
BDEPEND="${RDEPEND}"
