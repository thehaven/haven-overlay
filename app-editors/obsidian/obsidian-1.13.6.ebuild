# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop pax-utils xdg-utils

DESCRIPTION="A powerful knowledge base that works on top of a local folder of plain text Markdown files"
HOMEPAGE="https://obsidian.md"
SRC_URI="https://github.com/obsidianmd/obsidian-releases/releases/download/v${PV}/obsidian-${PV}.tar.gz"

LICENSE="Obsidian-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="appindicator pax-kernel wayland"

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
	appindicator? ( dev-libs/libappindicator:3 )
"

S="${WORKDIR}/${PN}-${PV}"

QA_PREBUILT="*"

src_prepare() {
	default
	
	# Fix permissions for the chrome-sandbox
	fperms 4711 chrome-sandbox
}

src_install() {
	local base_dir="/opt/obsidian"
	insinto "${base_dir}"
	doins -r .
	
	fperms +x "${base_dir}/obsidian"

	# Security: PaX marking for Electron
	if use pax-kernel; then
		pax-mark m "${ED}${base_dir}/obsidian"
	fi

	# Install wrapper script
	newbin "${FILESDIR}/obsidian.sh" obsidian

	# Icon and desktop entry
	# Note: The tarball usually includes resources/obsidian.png
	newicon resources/obsidian.png obsidian.png
	make_desktop_entry obsidian Obsidian obsidian "Office;Utility;"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
