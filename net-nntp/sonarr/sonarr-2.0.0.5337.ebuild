# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user systemd
BRANCH='develop'
SRC_URI="http://download.sonarr.tv/v2/${BRANCH}/mono/NzbDrone.${BRANCH}.${PV}.mono.tar.gz"

DESCRIPTION="Sonarr is a PVR for Usenet and BitTorrent users."
HOMEPAGE="http://www.sonarr.tv"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND="
	>=dev-lang/mono-3.12.1
	media-video/mediainfo
	dev-db/sqlite"
IUSE="updater"
#MY_PN="NzbDrone"
S=${WORKDIR}/${MY_PN}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/sonarr ${PN}
}

src_unpack() {
	unpack ${A}
	mv ${MY_PN} ${PN}
}

src_install() {
	newconfd "${FILESDIR}/${PN}.conf" ${PN}
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	keepdir /var/lib/${PN}
	fowners -R ${PN}:${PN} /var/lib/${PN}

	insinto /etc/${PN}
	insopts -m0660 -o ${PN} -g ${PN}

	insinto /etc/logrotate.d
	insopts -m0644 -o root -g root
	newins "${FILESDIR}/${PN}.logrotate" ${PN}
	diropts -g ${PN} -m0770
	keepdir /var/log/${PN}

	insinto "/usr/share/"
	doins -r "${S}"

	# Allow auto-updater, make source owned by sonarr user.
	if use updater; then
		fowners -R ${PN}:${PN} /usr/share/${PN}
	fi

	systemd_dounit "${FILESDIR}/sonarr.service"
	systemd_newunit "${FILESDIR}/sonarr.service" "${PN}@.service"
}
