# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="node-fetch"
inherit npm

DESCRIPTION="A light-weight module that brings Fetch API to node.js"
HOMEPAGE="https://github.com/node-fetch/node-fetch"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/data-uri-to-buffer
	dev-nodejs/fetch-blob
	dev-nodejs/formdata-polyfill
"
BDEPEND="${RDEPEND}"
