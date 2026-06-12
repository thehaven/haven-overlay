# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for popular Grafana plugins"
HOMEPAGE="https://grafana.com/grafana/plugins/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

IUSE="
	all-plugins
	piechart-panel
	worldmap-panel
	clock-panel
	polystat-panel
	discrete-panel
	status-panel
	bargauge-panel
	kubernetes-app
"

RDEPEND="
	piechart-panel? ( app-metrics/grafana-plugin-piechart )
	worldmap-panel? ( app-metrics/grafana-plugin-worldmap )
	clock-panel? ( app-metrics/grafana-plugin-clock )
	polystat-panel? ( app-metrics/grafana-plugin-polystat )
	discrete-panel? ( app-metrics/grafana-plugin-discrete )
	status-panel? ( app-metrics/grafana-plugin-status )
	bargauge-panel? ( app-metrics/grafana-plugin-bargauge )
	kubernetes-app? ( app-metrics/grafana-plugin-kubernetes )
"

pkg_postinst() {
	elog "Grafana plugins installed to /var/lib/grafana/plugins/"
	elog "Restart Grafana after installing plugins."
}
