# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NPM_AUTO_BIN=1
NPM_MODULE="typescript-language-server"
inherit npm

DESCRIPTION="LSP implementation for TypeScript using tsserver"
HOMEPAGE="https://www.npmjs.com/package/typescript-language-server"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="net-libs/nodejs"

pkg_postinst() {
	einfo "typescript-language-server ${PV}: LSP server for TypeScript/JS — works with OpenCode"
	einfo "Binary: /usr/bin/typescript-language-server"
}
