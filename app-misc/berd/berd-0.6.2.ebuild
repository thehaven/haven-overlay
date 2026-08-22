# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Berd — a desktop app for getting work done with any model"
HOMEPAGE="https://github.com/block/berd"
SRC_URI="https://github.com/block/berd/releases/download/v${PV}/Berd_${PV}_linux-x86_64.AppImage -> ${P}.AppImage"
S="${WORKDIR}/squashfs-root"

LICENSE="Apache-2.0 LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"

# Prebuilt Tauri AppImage: no source build, no stripping, no tests.
RESTRICT="strip test"
QA_PREBUILT="*"

# System libraries the bundled binaries link against (the AppImage also
# ships its own GTK plugin stack under /opt/berd/usr/lib, used via the
# GTK_* env vars set by the wrapper).
RDEPEND="
	net-libs/webkit-gtk:4.1
	net-libs/libsoup:3.0
	x11-libs/gtk+:3
	x11-libs/gdk-pixbuf
	dev-libs/glib
	x11-libs/pango
	x11-libs/cairo
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/mesa
	dev-libs/wayland
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXi
	app-crypt/libsecret
	dev-libs/libmanette
	app-text/enchant
	media-libs/harfbuzz
	dev-libs/icu
	dev-libs/libgcrypt
	dev-libs/libgpg-error
	app-crypt/mit-krb5
	sys-apps/systemd
	dev-db/sqlite
	media-libs/libwebp
	media-libs/libjpeg-turbo
	media-libs/libpng
	media-libs/lcms
	dev-libs/hyphen
	dev-libs/libgudev
	sys-libs/libseccomp
	sys-libs/libunwind
	net-libs/libpsl
	net-libs/nghttp2
	net-dns/libidn2
	app-arch/lz4
	app-arch/xz-utils
	app-arch/bzip2
	app-arch/brotli
	virtual/zlib
	dev-libs/libffi
	dev-libs/libpcre2
	media-gfx/graphite2
	dev-libs/fribidi
	media-libs/fontconfig
	media-libs/freetype
	dev-libs/libevdev
	dev-libs/elfutils
	sys-libs/libcap
	sys-apps/util-linux
	sys-libs/libselinux
	dev-libs/libtasn1
	dev-libs/libunistring
	dev-libs/libthai
	dev-libs/libdatrie
	sys-fs/e2fsprogs
	sys-apps/keyutils
	dev-libs/expat
	dev-lang/orc
"

src_unpack() {
	cp "${DISTDIR}/${P}.AppImage" "${WORKDIR}/${P}.AppImage" || die
	chmod +x "${WORKDIR}/${P}.AppImage" || die
	cd "${WORKDIR}" || die
	"${WORKDIR}/${P}.AppImage" --appimage-extract >/dev/null || die
}

src_install() {
	# Self-contained app tree under /opt/berd (AppImage AppDir layout).
	# usr/share/doc holds bundled dev-package docs — not needed at runtime.
	insinto /opt/${PN}
	doins -r "${S}"/usr
	rm -rf "${ED}"/opt/${PN}/usr/share/doc || die
	doins "${S}"/AppRun.wrapped
	doins -r "${S}"/apprun-hooks
	# AppRun.wrapped parses Exec= from a .desktop file in $APPDIR
	doins "${S}"/Berd.desktop
	fperms a+x /opt/${PN}/AppRun.wrapped
	fperms a+x /opt/${PN}/usr/bin/Berd /opt/${PN}/usr/bin/berdctl \
		/opt/${PN}/usr/bin/goosed

	# Wrapper: replicate the AppImage runtime env (GTK hook) then exec the
	# linuxdeploy launcher, which sets LD_LIBRARY_PATH for the bundled libs.
	dodir /usr/bin
	cat > "${ED}/usr/bin/berd" <<-EOF
		#!/bin/bash
		export APPDIR=/opt/${PN}
		. /opt/${PN}/apprun-hooks/linuxdeploy-plugin-gtk.sh
		exec /opt/${PN}/AppRun.wrapped "\$@"
	EOF
	fperms a+x /usr/bin/berd

	# berdctl talks to a running Berd instance; expose it as a CLI.
	dosym -r /opt/${PN}/usr/bin/berdctl /usr/bin/berdctl

	# Desktop entry + icons
	sed -e 's|^Exec=Berd$|Exec=/usr/bin/berd|' \
		-e 's|^Categories=$|Categories=Utility;|' \
		"${S}"/Berd.desktop > "${T}/berd.desktop" || die
	newmenu "${T}/berd.desktop" berd.desktop
	insinto /usr/share/icons
	doins -r "${S}"/usr/share/icons/hicolor
}

pkg_postinst() {
	einfo "Berd ${PV} installed."
	einfo "  GUI:  /usr/bin/berd"
	einfo "  CLI:  /usr/bin/berdctl (talks to a running Berd instance)"
	einfo ""
	einfo "Berd stores its data under ~/.local/share/ (Tauri default)."
}
