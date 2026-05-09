# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="OpenCode context manager for switching between configurations"
HOMEPAGE="https://github.com/hungthai1401/occtx"
SRC_URI="https://github.com/hungthai1401/occtx/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RESTRICT="network-sandbox test"

src_compile() {
	ego build -o ${PN} .
}

src_install() {
	dobin ${PN}
	einstalldocs
}
