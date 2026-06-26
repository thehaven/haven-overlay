# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="The React Framework"
HOMEPAGE="https://nextjs.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin "dist/bin/next" next
}
