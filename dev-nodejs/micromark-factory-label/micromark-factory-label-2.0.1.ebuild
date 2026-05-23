# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="micromark-factory-label"


DESCRIPTION="micromark factory to parse labels (found in media, definitions)"
HOMEPAGE="https://github.com/micromark/micromark/tree/main#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/devlop
	dev-nodejs/micromark-util-character
	dev-nodejs/micromark-util-symbol
	dev-nodejs/micromark-util-types
"
BDEPEND=""
