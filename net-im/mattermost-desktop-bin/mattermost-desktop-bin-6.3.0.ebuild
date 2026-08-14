# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Mattermost Desktop application"
HOMEPAGE="https://mattermost.com/"
SRC_URI="https://releases.mattermost.com/desktop/${PV}/mattermost-desktop-${PV}-linux-x64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libxshmfence
	media-libs/alsa-lib
	media-libs/mesa
	sys-apps/dbus
	dev-libs/nss
	dev-libs/nspr
	dev-libs/expat
	x11-libs/cairo
	x11-libs/pango
	media-libs/libglvnd
	x11-libs/libdrm
"

QA_PREBUILT="*"
S="${WORKDIR}/mattermost-desktop-${PV}-linux-x64"

src_install() {
	insinto /opt/mattermost-desktop
	doins -r *
	
	exeinto /opt/mattermost-desktop
	doexe mattermost-desktop chrome-sandbox
	fperms 4755 /opt/mattermost-desktop/chrome-sandbox
	
	dosym ../../opt/mattermost-desktop/mattermost-desktop /usr/bin/mattermost-desktop
}
