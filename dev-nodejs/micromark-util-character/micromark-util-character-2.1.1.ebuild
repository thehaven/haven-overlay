# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="micromark-util-character"
inherit npm

DESCRIPTION="micromark utility to handle character codes"
HOMEPAGE="https://github.com/micromark/micromark/tree/main#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/micromark-util-symbol
	dev-nodejs/micromark-util-types
"
BDEPEND="${RDEPEND}"
