# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Prometheus exporter for cloud provider cost metrics (AWS, GCP, Azure)"
HOMEPAGE="https://github.com/grafana/cloudcost-exporter"
SRC_URI="https://github.com/grafana/cloudcost-exporter/releases/download/v${PV}/cloudcost-explorer_Linux_x86_64.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

QA_PREBUILT="usr/bin/cloudcost-exporter"

src_install() {
	newbin cloudcost-explorer cloudcost-exporter
	fperms 0755 /usr/bin/cloudcost-exporter
}

pkg_postinst() {
	elog "cloudcost-exporter ${PV} installed."
	elog "Usage: cloudcost-exporter --help"
	elog "Metrics exposed at http://localhost:8080/metrics"
}
