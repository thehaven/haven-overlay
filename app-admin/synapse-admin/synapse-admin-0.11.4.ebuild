# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Admin UI for Matrix Synapse homeserver"
HOMEPAGE="https://github.com/Awesome-Technologies/synapse-admin"
SRC_URI="https://github.com/Awesome-Technologies/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/${PN}
	doins -r *
}
