# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="figures"

inherit npm

DESCRIPTION="Unicode symbols with fallbacks for older terminals"
HOMEPAGE="https://github.com/sindresorhus/figures#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-unicode-supported
"
BDEPEND="${RDEPEND}"
