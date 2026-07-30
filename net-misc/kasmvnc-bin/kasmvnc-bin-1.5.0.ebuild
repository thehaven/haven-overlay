# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="Modern VNC Server and client, web based and secure (Binary Release)"
HOMEPAGE="https://github.com/kasmtech/KasmVNC"
SRC_URI="https://github.com/kasmtech/KasmVNC/releases/download/v${PV}/kasmvncserver_bookworm_${PV}_amd64.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/openssl
	media-libs/libjpeg-turbo
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXdamage
	x11-libs/libXtst
	x11-libs/libXfixes
	x11-libs/pixman
"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

QA_PREBUILT="*"

src_unpack() {
	ar x "${DISTDIR}/${A}" || die
	tar xf data.tar.xz || die
}

src_install() {
	dobin usr/bin/kasmvncserver
	dobin usr/bin/vncserver
	
	insinto /usr/share/kasmvnc
	doins -r usr/share/kasmvnc/.
	
	insinto /etc/kasmvnc
	doins -r etc/kasmvnc/.
}
