# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

NPM_MODULE="@renovatebot/osv-offline"


DESCRIPTION="Node.js module"
HOMEPAGE="https://www.npmjs.com/package/@renovatebot/osv-offline"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/adm-zip
	dev-nodejs/debug
	dev-nodejs/fs-extra
	dev-nodejs/got
	dev-nodejs/luxon
	dev-nodejs/renovatebot-osv-offline-db
"
BDEPEND=""
