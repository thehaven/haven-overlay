# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="accepts"
inherit npm

DESCRIPTION="Higher-level content negotiation"
HOMEPAGE="https://github.com/jshttp/accepts#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/mime-types
	dev-nodejs/negotiator
"
BDEPEND="${RDEPEND}"
