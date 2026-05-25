# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_MODULE="typescript"
inherit npm

DESCRIPTION="TypeScript is a language for application scale JavaScript development"
HOMEPAGE="https://www.typescriptlang.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin bin/tsc tsc
	npm_install_bin bin/tsserver tsserver
}
