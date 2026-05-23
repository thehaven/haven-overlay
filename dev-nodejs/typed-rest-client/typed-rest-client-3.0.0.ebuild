# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="typed-rest-client"
inherit npm

DESCRIPTION="Node Rest and Http Clients for use with TypeScript"
HOMEPAGE="https://github.com/Microsoft/typed-rest-client#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/des-js
	dev-nodejs/js-md4
	dev-nodejs/qs
	dev-nodejs/tunnel
	dev-nodejs/underscore
"
BDEPEND="${RDEPEND}"
