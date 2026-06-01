# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="micromark-extension-gfm-autolink-literal"


DESCRIPTION="micromark extension to support GFM autolink literals"
HOMEPAGE="https://github.com/micromark/micromark-extension-gfm-autolink-literal#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/micromark-util-character
	dev-nodejs/micromark-util-sanitize-uri
	dev-nodejs/micromark-util-symbol
	dev-nodejs/micromark-util-types
"
BDEPEND=""
