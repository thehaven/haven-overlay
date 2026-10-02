# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Zig language server"
HOMEPAGE="https://github.com/zigtools/zls"
SRC_URI="https://github.com/zigtools/zls/releases/download/${PV}/zls-x86_64-linux.tar.xz -> ${P}-x86_64-linux.tar.xz"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="usr/bin/zls"

src_install() {
	dobin zls
	dodoc LICENSE README.md
}
