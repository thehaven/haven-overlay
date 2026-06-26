# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="A tiny (118 bytes), secure URL-friendly unique string ID generator"
HOMEPAGE="https://github.com/ai/nanoid#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin "bin/nanoid.js" nanoid
}
