# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Lync for Linux"
HOMEPAGE="http://fisil.com/linuxlync.html"
SRC_URI="http://fisil.com/linux/wync_debian64_v${PV}.deb"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
    mkdir "${S}"
    cd "${S}"
    unpack wync_debian64_v${PV}.deb 
    unpack ./data.tar.gz
}

src_install() {
    cp -pPR "${S}"/etc "${D}"/ || die "Installation failed"
    cp -pPR "${S}"/opt "${D}"/ || die "Installation failed"
    cp -pPR "${S}"/usr "${D}"/ || die "Installation failed"
	dosym /opt/wync_linux/wync.sh /usr/bin/wync
}
