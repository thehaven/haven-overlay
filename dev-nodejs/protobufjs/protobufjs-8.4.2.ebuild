# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="protobufjs"
inherit npm

DESCRIPTION="Protocol Buffers for JavaScript & TypeScript."
HOMEPAGE="https://github.com/protobufjs/protobuf.js#readme"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/long
"
BDEPEND="${RDEPEND}"
