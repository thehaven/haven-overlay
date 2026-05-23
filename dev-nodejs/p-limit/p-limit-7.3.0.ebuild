# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="p-limit"

inherit npm

DESCRIPTION="Run multiple promise-returning & async functions with limited concurrency"
HOMEPAGE="https://github.com/sindresorhus/p-limit#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/yocto-queue
"
BDEPEND=""
