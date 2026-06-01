# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="data-urls"
inherit npm

DESCRIPTION="Parses data: URLs"
HOMEPAGE="https://github.com/jsdom/data-urls#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/whatwg-mimetype
	dev-nodejs/whatwg-url
"
BDEPEND="${RDEPEND}"
