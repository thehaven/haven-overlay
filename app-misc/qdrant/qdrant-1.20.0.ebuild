# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="High-performance vector similarity search engine for AI applications"
HOMEPAGE="https://qdrant.tech https://github.com/qdrant/qdrant"

SRC_URI="
	amd64? ( https://github.com/qdrant/qdrant/releases/download/v${PV}/${PN}-x86_64-unknown-linux-gnu.tar.gz -> ${P}-amd64.tar.gz )
"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror strip"

QA_PREBUILT="usr/bin/qdrant"

src_install() {
	dobin qdrant

	newinitd "${FILESDIR}"/qdrant.initd qdrant
	newconfd "${FILESDIR}"/qdrant.confd qdrant

	insinto /usr/lib/systemd/system
	doins "${FILESDIR}"/qdrant.service

	keepdir /var/lib/qdrant
	keepdir /etc/qdrant

	insinto /etc/qdrant
	doins "${FILESDIR}"/config.yaml
}

pkg_postinst() {
	einfo "Qdrant vector database installed."
	einfo ""
	einfo "Configuration: /etc/qdrant/config.yaml"
	einfo "Data directory: /var/lib/qdrant"
	einfo ""
	einfo "Start with: rc-service qdrant start (OpenRC)"
	einfo "        or: systemctl start qdrant (systemd)"
	einfo ""
	einfo "Dashboard: http://localhost:6333/dashboard"
	einfo "REST API:  http://localhost:6333"
	einfo "gRPC API:  localhost:6334"
}
