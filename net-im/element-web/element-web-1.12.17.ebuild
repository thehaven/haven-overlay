# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A glossy Matrix collaboration client for the web"
HOMEPAGE="https://element.io/"
SRC_URI="https://github.com/element-hq/element-web/releases/download/v${PV}/element-v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

S="${WORKDIR}/element-v${PV}"

src_install() {
	insinto /usr/share/${PN}
	doins -r *
}
