# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="finalhandler"
inherit npm

DESCRIPTION="Node.js final http responder"
HOMEPAGE="https://github.com/pillarjs/finalhandler#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/debug
	dev-nodejs/encodeurl
	dev-nodejs/escape-html
	dev-nodejs/on-finished
	dev-nodejs/parseurl
	dev-nodejs/statuses
"
BDEPEND="${RDEPEND}"
