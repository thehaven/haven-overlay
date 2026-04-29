# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module-offline

DESCRIPTION="A Mattermost plugin to bridge with Matrix"
HOMEPAGE="https://github.com/mattermost/mattermost-plugin-matrix-bridge"
SRC_URI="https://github.com/mattermost/mattermost-plugin-matrix-bridge/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~haven/${PN}/${P}-vendor.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	ego build -ldflags "-s -w" -o mattermost-matrix-bridge ./server
}

src_install() {
	exeinto /usr/libexec/mattermost/plugins/${PN}/server
	doexe mattermost-matrix-bridge
	
	insinto /usr/libexec/mattermost/plugins/${PN}
	doins plugin.json
	
	einstalldocs
}
