# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd user

DESCRIPTION="The Free Software Media System"
HOMEPAGE="https://github.com/jellyfin/jellyfin"
MY_PN=${PN%-bin}
SRC_URI="amd64? ( https://repo.jellyfin.org/releases/server/linux/stable/server/jellyfin-server_${PV}_linux-amd64.tar.gz -> ${P}.tar.gz )"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="!media-tv/jellyfin"
RDEPEND="${DEPEND}
		media-video/ffmpeg[fontconfig,gmp,libass,libdrm,truetype,fribidi,vorbis,vdpau,vaapi,x264,x265,webp,bluray,zvbi,mp3,opus,theora]
		sys-process/at
		dev-db/sqlite:3
		media-libs/fontconfig
		media-libs/freetype
		dev-util/lttng-ust
		app-crypt/mit-krb5
		dev-libs/icu
		dev-libs/openssl"

S=${WORKDIR}/jellyfin-server_${PV}

pkg_setup() {
	einfo "creating user for ${MY_PN}"
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 /bin/bash /var/lib/${MY_PN} "${MY_PN}"
}

src_install() {
	einfo "updating root certificates for mono certificate store"
	cert-sync --user /etc/ssl/certs/ca-certificates.crt

	insinto /etc/${MY_PN}
	doins ${FILESDIR}/logging.json
	fowners -R "${MY_PN}:${MY_PN}" "/etc/${MY_PN}"

	cp "${FILESDIR}/${MY_PN}.conf.d" "${T}/${MY_PN}.conf.d" || die
	cp "${FILESDIR}/${MY_PN}.service.conf" "${T}/${MY_PN}.service.conf" || die

	sed -i "s|/usr/lib/|/usr/$(get_libdir)/|g" \
		"${T}/${MY_PN}.conf.d" \
		"${T}/${MY_PN}.service.conf" || die

	newconfd "${T}/${MY_PN}.conf.d" "${MY_PN}"
	newinitd "${FILESDIR}/${MY_PN}.init.d" "${MY_PN}"

	systemd_install_serviced ${T}/${MY_PN}.service.conf
	systemd_dounit ${FILESDIR}/${MY_PN}.service

	keepdir "/var/lib/${MY_PN}"
	fowners -R "${MY_PN}:${MY_PN}" "/var/lib/${MY_PN}"

	keepdir "/var/log/${MY_PN}"
	fowners -R "${MY_PN}:${MY_PN}" "/var/log/${MY_PN}"

	keepdir "/var/cache/${MY_PN}"
	fowners -R "${MY_PN}:${MY_PN}" "/var/cache/${MY_PN}"

	insinto /usr/$(get_libdir)/${MY_PN}/bin
	doins -r ${S}/*
	fperms 0755 /usr/$(get_libdir)/${MY_PN}/bin/${MY_PN}

	dosym /usr/$(get_libdir)/${MY_PN}/bin/${MY_PN} /usr/bin/${MY_PN}
}
