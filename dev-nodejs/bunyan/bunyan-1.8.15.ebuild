# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="bunyan"

inherit npm

DESCRIPTION="a JSON logging library for node.js services"
HOMEPAGE="https://github.com/trentm/node-bunyan#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/dtrace-provider
	dev-nodejs/moment
	dev-nodejs/mv
	dev-nodejs/safe-json-stringify
"
BDEPEND="${RDEPEND}"
