# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="find-babel-config"
inherit npm

DESCRIPTION="Find the closest babel config based on a directory"
HOMEPAGE="https://github.com/tleunen/find-babel-config#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/json5
"
BDEPEND="${RDEPEND}"
