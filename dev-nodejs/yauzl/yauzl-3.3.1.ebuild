# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="yauzl"
inherit npm

DESCRIPTION="yet another unzip library for node"
HOMEPAGE="https://github.com/thejoshwolfe/yauzl"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-nodejs/buffer-crc32
	dev-nodejs/pend
"
BDEPEND="${RDEPEND}"
