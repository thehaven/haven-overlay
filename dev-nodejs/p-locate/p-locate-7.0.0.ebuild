# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="p-locate"


DESCRIPTION="Get the first fulfilled promise that satisfies the provided testing function"
HOMEPAGE="https://github.com/sindresorhus/p-locate#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/p-limit
"
BDEPEND=""
