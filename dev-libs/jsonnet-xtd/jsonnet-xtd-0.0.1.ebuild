# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Jsonnet extended standard library (xtd)"
HOMEPAGE="https://github.com/jsonnet-libs/xtd"
SRC_URI="https://github.com/jsonnet-libs/xtd/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/xtd-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	insinto /usr/share/jsonnet-libs/xtd
	doins -r .
}
