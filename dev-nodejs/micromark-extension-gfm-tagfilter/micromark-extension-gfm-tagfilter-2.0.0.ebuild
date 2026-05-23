# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="micromark-extension-gfm-tagfilter"

inherit npm

DESCRIPTION="micromark extension to support GFM tagfilter"
HOMEPAGE="https://github.com/micromark/micromark-extension-gfm-tagfilter#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/micromark-util-types
"
BDEPEND=""
