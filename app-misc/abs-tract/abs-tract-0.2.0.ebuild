# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="All-in-one book metadata provider for Audiobookshelf"
HOMEPAGE="https://github.com/ahobsonsayers/abs-tract"
SRC_URI="https://github.com/ahobsonsayers/abs-tract/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	ego build -ldflags "-s -w" -o bin/${PN} .
}

src_install() {
	dobin bin/${PN}
	einstalldocs
}
