# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="router"
inherit npm

DESCRIPTION="Simple middleware-style router"
HOMEPAGE="https://github.com/pillarjs/router#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/debug
	dev-nodejs/depd
	dev-nodejs/is-promise
	dev-nodejs/parseurl
	dev-nodejs/path-to-regexp
"
BDEPEND="${RDEPEND}"
