# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user systemd

SRC_URI="https://github.com/theotherp/${PN}/releases/download/v${PV}/${PN}-${PV}-linux.zip -> ${P}.zip"

DESCRIPTION="Usenet meta search"
HOMEPAGE="https://github.com/theotherp/nzbhydra2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"
DEPEND=""
RDEPEND="virtual/jre
		systemd? ( sys-apps/systemd )"

S="${WORKDIR}/"

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 /opt/${PN} "${PN}"
}

src_install() {

	local dir="/opt/${PN}"
	insinto ${dir}
	doins lib/core-${PV}-exec.jar nzbhydra2wrapper.py nzbhydra2 || die

	keepdir /opt/${PN}
	fowners ${PN}:${PN} /opt/${PN} || die

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}@.service"

}
