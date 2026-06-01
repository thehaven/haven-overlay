# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="proxy-addr"
inherit npm

DESCRIPTION="Determine address of proxied request"
HOMEPAGE="https://github.com/jshttp/proxy-addr#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/forwarded
	dev-nodejs/ipaddr-js
"
BDEPEND="${RDEPEND}"
