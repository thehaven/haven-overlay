# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="jsonfile"
inherit npm

DESCRIPTION="Easily read/write JSON files."
HOMEPAGE="https://github.com/jprichardson/node-jsonfile#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/universalify
"
BDEPEND="${RDEPEND}"
