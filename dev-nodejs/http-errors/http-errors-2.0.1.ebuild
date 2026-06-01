# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="http-errors"
inherit npm

DESCRIPTION="Create HTTP error objects"
HOMEPAGE="https://github.com/jshttp/http-errors#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/depd
	dev-nodejs/inherits
	dev-nodejs/setprototypeof
	dev-nodejs/statuses
	dev-nodejs/toidentifier
"
BDEPEND="${RDEPEND}"
