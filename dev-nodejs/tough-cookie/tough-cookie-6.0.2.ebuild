# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="tough-cookie"
inherit npm

DESCRIPTION="RFC6265 Cookies and Cookie Jar for node.js"
HOMEPAGE="https://github.com/salesforce/tough-cookie"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tldts
"
BDEPEND="${RDEPEND}"
