# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit npm

DESCRIPTION="Data-Mapper ORM for TypeScript and ES2021+. Supports MySQL/MariaDB, PostgreSQ..."
HOMEPAGE="https://typeorm.io"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=""
BDEPEND="${RDEPEND}"

src_install() {
	npm_src_install
	npm_install_bin "cli.js" typeorm
	npm_install_bin "cli-ts-node-esm.js" typeorm-ts-node-esm
	npm_install_bin "cli-ts-node-commonjs.js" typeorm-ts-node-commonjs
}
