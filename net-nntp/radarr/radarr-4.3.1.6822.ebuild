# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit eutils user systemd

SRC_URI="https://github.com/Radarr/Radarr/releases/download/v${PV}/Radarr.develop.${PV}.linux-core-x64.tar.gz -> ${P}.tar.gz"

DESCRIPTION="A fork of Sonarr to work with movies à la Couchpotato.."
HOMEPAGE="http://www.radarr.video"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	media-video/mediainfo
	dev-db/sqlite"
MY_PN="Radarr"
S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	mv ${MY_PN} ${PN}
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/radarr ${PN}
}

src_install() {
	newconfd "${FILESDIR}/${PN}-v4.conf" ${PN}
	newinitd "${FILESDIR}/${PN}-v4.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	insinto "/usr/share/work/${MY_PN}"
	doins -r "${S}/"

	exeinto "/usr/share/work/${MY_PN}/radarr/"
	doexe "${S}/${MY_PN}"
	doexe "${S}/ffprobe"
	doexe "${S}/createdump"

	systemd_dounit "${FILESDIR}/radarr-v4.service"
	systemd_newunit "${FILESDIR}/radarr-v4.service" "${PN}@.service"

	# Update the mono trust store with latest certs:
	sudo -u ${PN} cert-sync --quiet --user /etc/ssl/certs/ca-certificates.crt
}

post_instal() {
	su -c "wget -O - https://curl.haxx.se/ca/cacert.pem | cert-sync --user /dev/stdin" -s /bin/sh radarr
}
