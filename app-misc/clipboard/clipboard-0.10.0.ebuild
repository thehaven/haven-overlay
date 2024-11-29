# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="Clipboard"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Cut, copy, and paste anything in your terminal"
HOMEPAGE="https://getclipboard.app/ https://github.com/Slackadays/Clipboard"
SRC_URI="https://github.com/Slackadays/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug lto wayland X"

DEPEND="X? ( x11-libs/libXext )
		wayland? ( dev-libs/wayland-protocols )
		dev-libs/openssl
		media-libs/alsa-lib
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_INSTALL_LIBDIR=$(get_libdir)"
		"-DCMAKE_C_FLAGS=$(usex debug "${CFLAGS}" "${CFLAGS} -DNDEBUG")"
		"-DCMAKE_CXX_FLAGS=$(usex debug "${CXXFLAGS}" "${CXXFLAGS} -DNDEBUG")"
		"-DNO_WAYLAND=$(usex !wayland)"
		"-DNO_X11=$(usex !X)"
		"-DNO_LTO=$(usex !lto)"
	)
	cmake_src_configure
}
