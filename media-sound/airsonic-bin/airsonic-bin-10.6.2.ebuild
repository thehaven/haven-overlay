# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

MY_PN="${PN//-bin}"
AIRSONIC_HOME="/var/lib/${MY_PN}"

DESCRIPTION="Airsonic is a personal media server, opensource fork of Subsonic"
HOMEPAGE="https://airsonic.github.io/"
SRC_URI="https://github.com/airsonic/airsonic/releases/download/v${PV}/airsonic.war"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ffmpeg +lame systemd"

DEPEND=""
RDEPEND="
	acct-user/airsonic
	acct-group/airsonic
	virtual/jre
	lame? ( media-sound/lame )
	ffmpeg? ( media-video/ffmpeg )
	systemd? ( sys-apps/systemd )
"

S="${WORKDIR}/"

src_install() {
	insinto "/usr/libexec/airsonic"
	doins "${DISTDIR}"/airsonic.war

	diropts -m750

	keepdir /var/log/${MY_PN}
	keepdir ${AIRSONIC_HOME}

	fowners ${MY_PN}:${MY_PN} ${AIRSONIC_HOME}
	fowners ${MY_PN}:${MY_PN} /var/log/${MY_PN}

	newinitd "${FILESDIR}/${MY_PN}.initd" ${MY_PN}
	newconfd "${FILESDIR}/${MY_PN}.confd" ${MY_PN}

	if use systemd; then
		systemd_dounit "${FILESDIR}"/${MY_PN}.service
	fi

	if use ffmpeg; then
		dodir ${AIRSONIC_HOME}/transcode
		dosym /usr/bin/ffmpeg ${AIRSONIC_HOME}/transcode/ffmpeg
	fi

	if use lame; then
		dodir ${AIRSONIC_HOME}/transcode
		dosym /usr/bin/lame ${AIRSONIC_HOME}/transcode/lame
	fi
}
