# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="run-parallel"

inherit npm

DESCRIPTION="Run an array of functions in parallel"
HOMEPAGE="https://github.com/feross/run-parallel"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/queue-microtask
"
BDEPEND="${RDEPEND}"
