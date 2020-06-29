# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="DBus protocol binding for libvirt native C API"
HOMEPAGE="http://libvirt.org"
SRC_URI="http://www.libvirt.org/sources/dbus/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
    sys-apps/dbus
	app-emulation/libvirt
	app-emulation/libvirt-glib
	sys-auth/polkit
	acct-user/libvirtdbus"
BDEPEND="
	dev-util/ninja"

src_configure() {
	local emesonargs=(
	    -D dbus_conf_dir=/usr/share/dbus-1/system.d
	)
	meson_src_configure
}

