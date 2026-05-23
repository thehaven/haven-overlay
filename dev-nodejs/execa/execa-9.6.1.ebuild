# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="execa"

inherit npm

DESCRIPTION="Process execution for humans"
HOMEPAGE="https://github.com/sindresorhus/execa#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/cross-spawn
	dev-nodejs/figures
	dev-nodejs/get-stream
	dev-nodejs/human-signals
	dev-nodejs/is-plain-obj
	dev-nodejs/is-stream
	dev-nodejs/npm-run-path
	dev-nodejs/pretty-ms
	dev-nodejs/signal-exit
	dev-nodejs/sindresorhus-merge-streams
	dev-nodejs/strip-final-newline
	dev-nodejs/yoctocolors
"
BDEPEND=""
