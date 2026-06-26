# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="A comprehensive library for mime-type mapping"
HOMEPAGE="https://github.com/broofa/mime#readme"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin "bin/cli.js" mime
}
