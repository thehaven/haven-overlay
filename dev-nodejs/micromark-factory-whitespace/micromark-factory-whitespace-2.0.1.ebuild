# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="micromark-factory-whitespace"
inherit npm

DESCRIPTION="micromark factory to parse markdown whitespace (found in lots of places)"
HOMEPAGE="https://github.com/micromark/micromark/tree/main#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/micromark-factory-space
	dev-nodejs/micromark-util-character
	dev-nodejs/micromark-util-symbol
	dev-nodejs/micromark-util-types
"
BDEPEND="${RDEPEND}"
