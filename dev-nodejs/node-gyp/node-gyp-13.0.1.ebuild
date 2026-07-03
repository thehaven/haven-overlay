# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="Node.js native addon build tool"
HOMEPAGE="https://github.com/nodejs/node-gyp#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_PREBUILT='*.node'
RESTRICT='strip'

RDEPEND=""
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin "bin/node-gyp.js" node-gyp
}
