# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="fetch-blob"

inherit npm

DESCRIPTION="Blob & File implementation in Node.js, originally from node-fetch."
HOMEPAGE="https://github.com/node-fetch/fetch-blob#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/node-domexception
"
BDEPEND=""
