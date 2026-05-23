# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="get-stream"
inherit npm

DESCRIPTION="Get a stream as a string, Buffer, ArrayBuffer or array"
HOMEPAGE="https://github.com/sindresorhus/get-stream#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/is-stream
	dev-nodejs/sec-ant-readable-stream
"
BDEPEND="${RDEPEND}"
