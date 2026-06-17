# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Headless browser service for rendering Grafana panels to PNG/PDF"
HOMEPAGE="https://github.com/grafana/grafana-image-renderer"
SRC_URI="https://github.com/grafana/grafana-image-renderer/releases/download/v${PV}/grafana-image-renderer-linux-amd64 -> grafana-image-renderer-${PV}"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+systemd"

QA_PREBUILT="usr/bin/grafana-image-renderer"

RDEPEND="
	www-client/chromium
	systemd? ( sys-apps/systemd )
"

src_unpack() {
	mkdir -p "${S}" || die
	cp "${DISTDIR}/grafana-image-renderer-${PV}" "${S}/grafana-image-renderer" || die
}

src_install() {
	dobin grafana-image-renderer
	fperms 0755 /usr/bin/grafana-image-renderer

	if use systemd; then
		systemd_dounit "${FILESDIR}/grafana-image-renderer.service"
	fi
}

pkg_postinst() {
	elog "grafana-image-renderer ${PV} installed."
	elog ""
	elog "Configuration: set GF_RENDERING_SERVER_URL in Grafana to:"
	elog "  http://localhost:8081/render"
	if use systemd; then
		elog ""
		elog "Start the service:"
		elog "  systemctl enable --now grafana-image-renderer"
	fi
	ewarn "Requires www-client/chromium."
	ewarn "Recommended: 16 GiB RAM, 4 CPU cores."
}
