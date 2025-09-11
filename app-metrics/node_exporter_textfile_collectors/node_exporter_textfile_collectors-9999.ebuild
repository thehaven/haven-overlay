# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Prometheus node-exporter community textfile collector scripts"
HOMEPAGE="https://github.com/prometheus-community/node-exporter-textfile-collector-scripts"
EGIT_REPO_URI="https://github.com/prometheus-community/node-exporter-textfile-collector-scripts.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="cron"

# Git fetch is handled by live ebuild helpers
inherit git-r3

RDEPEND="
	app-metrics/node_exporter
"
DEPEND="${RDEPEND}"
BDEPEND=""

src_install() {
	# Install provided scripts (adjust path as needed)
	exeinto /usr/libexec/node-exporter-textfile-collector-scripts
	doexe scripts/*

	# Optionally install crontab entry when USE=cron is enabled
	if use cron; then
    	# Ensure the collector directory exists for script and node_exporter output
    	dodir /var/lib/node_exporter/textfile_collector
    	fperms 0750 /var/lib/node_exporter/textfile_collector
    	insinto /etc/cron.d
    	newins "${FILESDIR}/node-exporter-collector.cron" node-exporter-collector
	fi

	einstalldocs
}
