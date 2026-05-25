# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="whatwg-url"
inherit npm

DESCRIPTION="An implementation of the WHATWG URL Standard's URL API and parsing machinery"
HOMEPAGE="https://github.com/jsdom/whatwg-url#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/exodus-bytes
	dev-nodejs/tr46
	dev-nodejs/webidl-conversions
"
BDEPEND="${RDEPEND}"
