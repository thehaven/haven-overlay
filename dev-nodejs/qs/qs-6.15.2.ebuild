# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="qs"

inherit npm

DESCRIPTION="A querystring parser that supports nesting and arrays, with a depth limit"
HOMEPAGE="https://github.com/ljharb/qs"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/side-channel
"
BDEPEND="${RDEPEND}"
