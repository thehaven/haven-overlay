# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils user systemd

SRC_URI="https://github.com/readarr/Readarr/releases/download/v${PV}/Readarr.develop.${PV}.linux-core-x64.tar.gz -> ${P}.tar.gz"

DESCRIPTION="Looks and smells like Sonarr but made for music. http://readarr.audio/"
HOMEPAGE="https://github.com/readarr/Readarr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
RDEPEND="
	>=dev-lang/mono-3.12.1
	dev-util/lttng-ust
	media-libs/chromaprint[tools]
	net-misc/curl
	www-client/elinks
	"
MY_PN="Readarr"
S=${WORKDIR}/${MY_PN}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/readarr ${PN}
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

	insinto "/usr/share/work"
	doins -r "${S}/${MY_PN}"

	exeinto "/usr/share/work/${MY_PN}"
	doexe "${S}/${MY_PN}/${MY_PN}"

	systemd_dounit "${FILESDIR}/${PN}.service"
	systemd_newunit "${FILESDIR}/${PN}.service" "${PN}@.service"

	# Update the mono trust store with latest certs:
	sudo -u ${PN} cert-sync --quiet --user /etc/ssl/certs/ca-certificates.crt
}

post_instal() {
	su -c "wget -O - https://curl.haxx.se/ca/cacert.pem | cert-sync --user /dev/stdin" -s /bin/sh readarr
}
