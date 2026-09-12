# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="P2P based file distribution system"
HOMEPAGE="https://d7y.io"
SRC_URI="https://github.com/dragonflyoss/Dragonfly2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="network-sandbox"

BDEPEND=">=dev-lang/go-1.22"

S="${WORKDIR}/Dragonfly2-${PV}"

src_compile() {
	ego build -o dfdaemon ./cmd/dfdaemon
	ego build -o dfget ./cmd/dfget
}

src_install() {
	dobin dfdaemon dfget
}
