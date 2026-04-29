# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module-offline systemd tmpfiles

DESCRIPTION="A sliding sync (MSC3575) proxy for Matrix"
HOMEPAGE="https://github.com/matrix-org/sliding-sync"
SRC_URI="https://github.com/matrix-org/sliding-sync/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~haven/${PN}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="postgres"

DEPEND="acct-user/matrix-sliding-sync acct-group/matrix-sliding-sync"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	ego build -ldflags "-s -w -X main.version=${PV}" -o syncv3 ./cmd/syncv3
}

src_install() {
	newbin syncv3 matrix-sliding-sync
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles
}
