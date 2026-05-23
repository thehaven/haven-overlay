# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="@qnighy/marshal"

inherit npm

DESCRIPTION="Decoder for Ruby's Marshal"
HOMEPAGE="https://github.com/qnighy/marshal-js"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/babel-runtime-corejs3
"
BDEPEND=""
