# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit systemd

# Zip asset name resolved per version by metadata/bump-hooks/net-nntp/nzbhydra2
# (naming changed between v4.x -linux.zip and v8.x -amd64-linux.zip).
NZBHYDRA2_ZIP="nzbhydra2-4.7.6-linux.zip"
SRC_URI="https://github.com/theotherp/${PN}/releases/download/v${PV}/${NZBHYDRA2_ZIP} -> ${P}.zip"

DESCRIPTION="Usenet meta search"
HOMEPAGE="https://github.com/theotherp/nzbhydra2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"
DEPEND="	acct-user/nzbhydra2
"
RDEPEND="virtual/jre
		systemd? ( sys-apps/systemd )"

S="${WORKDIR}/"


src_install() {

	local dir="/opt/${PN}"

	insinto ${dir}
	doins nzbhydra2wrapper.py readme.md changelog.md || die
	insinto ${dir}/lib
	doins lib/core-${PV}-exec.jar || die

	exeinto ${dir}
	doexe nzbhydra2 || die

	fowners -R ${PN}:${PN} /opt/${PN} || die

	keepdir /opt/${PN}/data
	mkdir -p /opt/${PN}/data/logs && chown -R ${PN}:${PN} /opt/${PN}/data

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}@.service"

}

post_instal() {
	if use systemd; then systemctl daemon-reload; fi
}
