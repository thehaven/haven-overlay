# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module-offline systemd tmpfiles

DESCRIPTION="High-Performance server for NATS"
HOMEPAGE="https://nats.io/"
SRC_URI="https://github.com/nats-io/nats-server/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~haven/${PN}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND="acct-user/nats acct-group/nats"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.22"

src_compile() {
	ego build -ldflags "-s -w -X github.com/nats-io/nats-server/v2/server.gitCommit=v${PV}" -o ${PN} .
}

src_install() {
	dobin ${PN}
	einstalldocs

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	dotmpfiles "${FILESDIR}"/${PN}.tmpfiles

	insinto /etc/nats
	doins docker/nats-server.conf
}
