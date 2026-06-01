# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="tr46"
inherit npm

DESCRIPTION="An implementation of the Unicode UTS #46: Unicode IDNA Compatibility Processing"
HOMEPAGE="https://github.com/jsdom/tr46#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/punycode
"
BDEPEND="${RDEPEND}"
