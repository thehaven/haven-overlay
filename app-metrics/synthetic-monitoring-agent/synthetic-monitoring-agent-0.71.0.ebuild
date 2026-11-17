# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Grafana Synthetic Monitoring agent for network and browser checks"
HOMEPAGE="https://github.com/grafana/synthetic-monitoring-agent"
SRC_URI="https://github.com/grafana/synthetic-monitoring-agent/releases/download/v${PV}/synthetic-monitoring-agent-v${PV}-linux-amd64.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"

QA_PREBUILT="usr/bin/synthetic-monitoring-agent"

src_install() {
	dobin synthetic-monitoring-agent
	fperms 0755 /usr/bin/synthetic-monitoring-agent
}

pkg_postinst() {
	elog "synthetic-monitoring-agent ${PV} installed."
	elog "Usage: synthetic-monitoring-agent --help"
	elog "Requires Grafana Cloud Synthetic Monitoring API token."
}
