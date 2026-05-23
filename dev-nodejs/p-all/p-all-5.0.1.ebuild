# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="p-all"

inherit npm

DESCRIPTION="Run promise-returning & async functions concurrently with optional limited concurrency"
HOMEPAGE="https://github.com/sindresorhus/p-all#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/p-map
"
BDEPEND=""
