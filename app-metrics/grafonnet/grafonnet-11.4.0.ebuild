# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GRAFONNET_COMMIT="f0fb5ab287e3d8ca8b924519aaa869f7a5f111c9"

DESCRIPTION="Jsonnet library for generating Grafana dashboards"
HOMEPAGE="https://github.com/grafana/grafonnet"
SRC_URI="https://github.com/grafana/grafonnet/archive/f0fb5ab.tar.gz -> grafonnet-${PV}.tar.gz"
S="${WORKDIR}/grafonnet-${GRAFONNET_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="docsonnet xtd"

RDEPEND="
	docsonnet? ( dev-libs/jsonnet-docsonnet )
	xtd? ( dev-libs/jsonnet-xtd )
"

src_install() {
	insinto "/usr/share/jsonnet-libs/grafonnet/${PV}"
	doins -r "gen/grafonnet-v${PV}"/*

	insinto /usr/share/jsonnet-libs/grafonnet/custom
	doins -r custom/*

	dodoc README.md
}

pkg_postinst() {
	elog "grafonnet ${PV} installed to /usr/share/jsonnet-libs/grafonnet/${PV}/"
	elog "Custom utilities at /usr/share/jsonnet-libs/grafonnet/custom/"
	elog ""
	elog "Usage with jsonnet:"
	elog "  jsonnet -J /usr/share/jsonnet-libs/grafonnet/${PV} your-dashboard.jsonnet"
	elog ""
	elog "Dependencies (optional):"
	elog "  USE=docsonnet: dev-libs/jsonnet-docsonnet (doc-util)"
	elog "  USE=xtd:       dev-libs/jsonnet-xtd (extended stdlib)"
}
