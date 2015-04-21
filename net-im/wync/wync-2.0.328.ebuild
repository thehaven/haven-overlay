# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Lync for Linux"
HOMEPAGE="http://fisil.com/linuxlync.html"
SRC_URI="http://fisil.com/linux/wync_ubuntu64_v${PV}.deb"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/openssl
	net-misc/freerdp
	sys-libs/glibc
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXfixes
	x11-libs/libXdmcp
	x11-libs/libXau
"
RDEPEND="${DEPEND}"

src_unpack() {
    mkdir "${S}"
    cd "${S}"
    unpack wync_ubuntu64_v${PV}.deb 
    unpack ./data.tar.gz
}

src_install() {
    cp -pPR "${S}"/etc "${D}"/ || die "Installation failed"
    cp -pPR "${S}"/opt "${D}"/ || die "Installation failed"
    cp -pPR "${S}"/usr "${D}"/ || die "Installation failed"
	dosym /opt/wync_linux/wync.sh /usr/bin/wync
}
