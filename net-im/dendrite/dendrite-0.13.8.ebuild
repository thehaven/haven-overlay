# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module-offline systemd tmpfiles

DESCRIPTION="Second-generation Matrix homeserver written in Go"
HOMEPAGE="https://github.com/matrix-org/dendrite"
SRC_URI="https://github.com/matrix-org/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~haven/${PN}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="postgres jetstream"

DEPEND="acct-user/dendrite acct-group/dendrite
	jetstream? ( dev-db/nats-server )"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	ego build -ldflags "-s -w" -o ${PN} ./cmd/dendrite
}

src_install() {
	dobin ${PN}
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles

	insinto /etc/dendrite
	doins dendrite-sample.yaml
}
