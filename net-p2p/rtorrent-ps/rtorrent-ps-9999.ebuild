# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils flag-o-matic git-r3

DESCRIPTION="Extended rTorrent distribution with UI enhancements, colorization, and some added features"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
EGIT_REPO_URI="git://github.com/rakshasa/rtorrent.git"
EGIT_BRANCH="feature-bind"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+daemon debug ipv6 selinux test +xmlrpc"

COMMON_DEPEND="=net-libs/libtorrent-9999
	>=net-misc/curl-7.19.1
	sys-libs/ncurses:0=
	xmlrpc? ( dev-libs/xmlrpc-c )"
RDEPEND="${COMMON_DEPEND}
	daemon? ( app-misc/screen )
	selinux? ( sec-policy/selinux-rtorrent )
"
DEPEND="${COMMON_DEPEND}
	dev-util/cppunit
	virtual/pkgconfig"

DOCS=( doc/rtorrent.rc )

src_prepare() {
	for i in ${FILESDIR}/*.{cc,h,patch}; do
		cp "$i" "${S}"
	done

	sed -i doc/scripts/update_commands_0.9.sed \
		-e "s:':\":g"
	sed -i {command_pyroscope.cc,ui_pyroscope.cc} \
		-e "s:tr1:std:" \
		-e "s:print_download_info:print_download_info_full:"

	sed -i configure.ac \
		-e "s:\\(AC_DEFINE(HAVE_CONFIG_H.*\\):\1\nAC_DEFINE(RT_HEX_VERSION, 0x000907, version checks):"
	sed -i src/ui/download_list.cc \
		-e "s:rTorrent \" VERSION:rTorrent-PS git~$(git rev-parse --short $_commit) \" VERSION:"

	for i in *.patch; do
		sed -f doc/scripts/update_commands_0.9.sed -i $i
		epatch $i
	done
	for i in *.{cc,h}; do
		sed -f doc/scripts/update_commands_0.9.sed -i $i
		cp $i src/$i
	done

	eautoreconf
}

src_configure() {
	append-cflags -fno-strict-aliasing -Wno-terminate
	append-cxxflags -fno-strict-aliasing -Wno-terminate

	# configure needs bash or script bombs out on some null shift, bug #291229
	CONFIG_SHELL=${BASH} econf \
		--disable-dependency-tracking \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_with xmlrpc xmlrpc-c) --enable-largefile
}

src_install() {
	default

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
	fi
}
