# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="tldts"
inherit npm

DESCRIPTION="Library to work against complex domain names, subdomains and URIs."
HOMEPAGE="https://github.com/remusao/tldts#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/tldts-core
"
BDEPEND="${RDEPEND}"
