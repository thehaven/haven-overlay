# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils user systemd

SRC_URI="https://github.com/Jackett/Jackett/releases/download/v${PV}/Jackett.Binaries.Mono.tar.gz"

DESCRIPTION="API Support for your favorite torrent trackers."
HOMEPAGE="https://github.com/Jackett/Jackett"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="
	>=dev-lang/mono-3.12.1
	net-misc/curl
	"
S=${WORKDIR}/${MY_PN}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/jackett ${PN}
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
    mkdir -p /var/log/${PN} && chown ${PN}:${PN} /var/log/${PN}

	insinto "/usr/share/"
	doins -r "${S}"

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}@.service"
}

post_instal() {
    # Fix certificates for jackett user:
	# https://github.com/Jackett/Jackett/issues/1179
	su -c "wget -O - https://curl.haxx.se/ca/cacert.pem | cert-sync --user /dev/stdin" -s /bin/sh jackett
}
