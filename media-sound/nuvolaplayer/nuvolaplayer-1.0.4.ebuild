# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Cloud music service player for the Linux Desktop"
HOMEPAGE="http://projects.fenryxo.cz/Nuvola_Player/Main_page/"
SRC_URI="https://launchpad.net/nuvola-player/releases-1.x/${PV}/+download/${P}.tar.gz"
inherit waf-utils

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="indicator"

DEPEND=">=dev-libs/glib-2.26
		>=dev-libs/libgee-0.5
		>=net-libs/libsoup-2.30
		>=x11-libs/gtk+-2.20
		>=net-libs/webkit-gtk-1.2
		>=dev-lang/python-2.6
		>=dev-lang/vala-0.12
		>=x11-libs/libnotify-0.4
		x11-libs/libX11
		dev-libs/libunique
		dev-util/intltool
		gnome-base/librsvg
		indicator? ( dev-libs/libindicate dev-libs/libdbusmenu )
"
RDEPEND="${DEPEND}"

src_configure() {
		local myconf=''
		if use "indicator"; then
			myconf=${myconf} --with-indicator-sound-maverick
		fi
		waf-utils_src_configure ${myconf}
}

src_compile() {
		waf-utils_src_compile
}

src_install() {
		waf-utils_src_install
}
