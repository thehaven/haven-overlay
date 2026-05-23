# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="micromark-util-decode-string"
inherit npm

DESCRIPTION="micromark utility to decode markdown strings"
HOMEPAGE="https://github.com/micromark/micromark/tree/main#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/decode-named-character-reference
	dev-nodejs/micromark-util-character
	dev-nodejs/micromark-util-decode-numeric-character-reference
	dev-nodejs/micromark-util-symbol
"
BDEPEND="${RDEPEND}"
