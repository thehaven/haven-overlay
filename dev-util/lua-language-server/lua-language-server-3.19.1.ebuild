# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Lua language server"
HOMEPAGE="https://github.com/LuaLS/lua-language-server"
SRC_URI="https://github.com/LuaLS/${PN}/releases/download/${PV}/${PN}-${PV}-linux-x64.tar.gz -> ${P}-linux-x64.tar.gz"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="usr/lib64/${PN}/bin/lua-language-server"

src_install() {
	insinto /usr/lib64/${PN}
	doins -r bin locale meta script debugger.lua main.lua
	fperms +x /usr/lib64/${PN}/bin/lua-language-server
	dosym ../lib64/${PN}/bin/lua-language-server /usr/bin/lua-language-server
	dodoc changelog.md
}
