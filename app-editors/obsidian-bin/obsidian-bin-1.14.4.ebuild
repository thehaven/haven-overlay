# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg-utils

DESCRIPTION="A powerful knowledge base that works on top of a local folder of plain text Markdown files"
HOMEPAGE="https://obsidian.md"
SRC_URI="https://github.com/obsidianmd/obsidian-releases/releases/download/v${PV}/obsidian_${PV}_amd64.deb"

LICENSE="Obsidian-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

QA_PREBUILT="*"

src_unpack() {
	# Extract the .deb file
	ar x "${DISTDIR}/${A}" || die
	tar xf data.tar.xz || die
}

src_prepare() {
	default
}

src_install() {
	insinto /opt/Obsidian
	doins -r usr/lib/obsidian/.

	fperms +x /opt/Obsidian/obsidian

	dosym /opt/Obsidian/obsidian /usr/bin/obsidian

	# Icon and desktop entry
	doicon usr/share/icons/hicolor/512x512/apps/obsidian.png
	make_desktop_entry obsidian Obsidian obsidian "Office;Utility;"
}

pkg_postinst() {
	xdg_icon_cache_update
}
