# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="decode-named-character-reference"


DESCRIPTION="Decode named character references"
HOMEPAGE="https://github.com/wooorm/decode-named-character-reference#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/character-entities
"
BDEPEND=""
