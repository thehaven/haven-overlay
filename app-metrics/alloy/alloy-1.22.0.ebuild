# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="OpenTelemetry Collector distribution with programmable pipelines"
HOMEPAGE="https://grafana.com/oss/alloy-opentelemetry-collector/"
SRC_URI="https://github.com/grafana/alloy/releases/download/v${PV}/alloy-linux-amd64.zip"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+systemd"

BDEPEND="app-arch/unzip"

QA_PREBUILT="usr/bin/alloy"

RDEPEND="
	acct-user/alloy
	acct-group/alloy
"

src_install() {
	newbin alloy-linux-amd64 alloy
	fperms 0755 /usr/bin/alloy

	if use systemd; then
		systemd_dounit "${FILESDIR}/alloy.service"
	fi

	keepdir /etc/alloy
	keepdir /var/lib/alloy
}

pkg_postinst() {
	elog "Grafana Alloy ${PV} installed."
	elog ""
	elog "Quick start:"
	elog "  alloy run /etc/alloy/config.alloy"
	elog ""
	elog "Configuration:"
	elog "  Place your configuration at /etc/alloy/config.alloy"
	elog "  Docs: https://grafana.com/docs/alloy/latest/"
	if use systemd; then
		elog ""
		elog "Start the service:"
		elog "  systemctl enable --now alloy"
	fi
}
