# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="widest-line"
inherit npm

DESCRIPTION="Get the visual width of the widest line in a string - the number of columns required to display it"
HOMEPAGE="https://github.com/sindresorhus/widest-line#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/string-width
"
BDEPEND="${RDEPEND}"
