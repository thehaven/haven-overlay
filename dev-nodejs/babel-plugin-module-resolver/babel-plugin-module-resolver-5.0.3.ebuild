# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="babel-plugin-module-resolver"
inherit npm

DESCRIPTION="Module resolver plugin for Babel"
HOMEPAGE="https://github.com/tleunen/babel-plugin-module-resolver#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/find-babel-config
	dev-nodejs/glob
	dev-nodejs/pkg-up
	dev-nodejs/reselect
	dev-nodejs/resolve
"
BDEPEND="${RDEPEND}"
