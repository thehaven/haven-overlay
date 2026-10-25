# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

XSERVER_VERSION="21.1.13"

DESCRIPTION="Modern VNC Server and client, web based and secure (Source Build)"
HOMEPAGE="https://github.com/kasmtech/KasmVNC"
SRC_URI="
	https://github.com/kasmtech/KasmVNC/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://www.x.org/releases/individual/xserver/xorg-server-${XSERVER_VERSION}.tar.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dri3 +opengl"

COMMON_DEPEND="
	dev-libs/openssl:0=
	media-libs/libjpeg-turbo:=
	media-libs/libwebp:=
	sys-libs/zlib:=
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/pixman
	opengl? ( media-libs/libglvnd[X] )
"
RDEPEND="${COMMON_DEPEND}
	>=net-libs/nodejs-18
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
	x11-libs/libXi
	x11-libs/libXrender
	x11-libs/xtrans
"
BDEPEND="
	virtual/pkgconfig
	sys-devel/gettext
	>=net-libs/nodejs-18
"

S="${WORKDIR}/KasmVNC-${PV}"

src_unpack() {
	default
	# Unpack Xorg into the KasmVNC tree as required by their build system
	mkdir -p "${S}/unix/xserver" || die
	tar xf "${DISTDIR}/xorg-server-${XSERVER_VERSION}.tar.xz" -C "${S}/unix/xserver" --strip-components=1 || die
}

src_prepare() {
	cmake_src_prepare
	
	# Apply KasmVNC's patches to the Xorg source
	cd "${S}/unix/xserver" || die
	for p in ../xserver${XSERVER_VERSION%.*}.patch; do
		[[ -f "$p" ]] && eapply "$p"
	done
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_VIEWER=OFF
		-DBUILD_SERVER=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	
	# Install systemd unit if provided by upstream or custom
	# systemd_dounit "${S}/contrib/systemd/kasmvnc.service"
}
