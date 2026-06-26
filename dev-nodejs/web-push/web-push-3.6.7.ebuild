# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="Web Push library for Node.js"
HOMEPAGE="https://github.com/web-push-libs/web-push#readme"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin "src/cli.js" web-push
}
