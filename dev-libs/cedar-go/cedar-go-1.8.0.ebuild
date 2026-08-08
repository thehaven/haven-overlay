# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Golang implementation of the Cedar Policy Language"
HOMEPAGE="https://github.com/cedar-policy/cedar-go"
SRC_URI="https://github.com/cedar-policy/cedar-go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~haven/cedar-go/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent module licenses
LICENSE+=" BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Library only — compile and verify, install nothing user-visible
src_compile() {
	ego build ./...
}

src_test() {
	ego test ./...
}

src_install() {
	einstalldocs
}
