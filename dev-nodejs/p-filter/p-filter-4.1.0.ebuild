# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="p-filter"

inherit npm

DESCRIPTION="Filter promises concurrently"
HOMEPAGE="https://github.com/sindresorhus/p-filter#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/p-map
"
BDEPEND="${RDEPEND}"
