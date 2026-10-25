# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="OpenObserve is cloud-native observability platform for logs, metrics, traces"
HOMEPAGE="https://openobserve.ai/ https://github.com/openobserve/openobserve"
BASE_URI="https://downloads.openobserve.ai/releases/openobserve/v${PV}"
SRC_URI="
	amd64? ( ${BASE_URI}/openobserve-v${PV}-linux-amd64.tar.gz -> ${P}-amd64.tar.gz )
	arm64? ( ${BASE_URI}/openobserve-v${PV}-linux-arm64.tar.gz -> ${P}-arm64.tar.gz )
"
S="${WORKDIR}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
RESTRICT="test"

RDEPEND="
	acct-group/openobserve
	acct-user/openobserve
	virtual/zlib
"

QA_PREBUILT="usr/bin/openobserve"

src_install() {
	dobin openobserve

	systemd_dounit "${FILESDIR}/openobserve.service"

	newinitd "${FILESDIR}/openobserve.initd" openobserve
	newconfd "${FILESDIR}/openobserve.confd" openobserve

	insinto /etc/openobserve
	newins "${FILESDIR}/openobserve.env" openobserve.env
	fowners -R root:openobserve /etc/openobserve
	fperms 0750 /etc/openobserve
	fperms 0640 /etc/openobserve/openobserve.env

	keepdir /var/lib/openobserve
	fowners openobserve:openobserve /var/lib/openobserve
	fperms 0750 /var/lib/openobserve
}

pkg_postinst() {
	elog "OpenObserve has been installed."
	elog "Web interface defaults to http://localhost:5080"
	elog "Configuration file: /etc/openobserve/openobserve.env"
	elog
	elog "To start OpenObserve with OpenRC:"
	elog "  rc-service openobserve start"
	elog "  rc-update add openobserve default"
	elog
	elog "To start OpenObserve with systemd:"
	elog "  systemctl enable --now openobserve.service"
}
