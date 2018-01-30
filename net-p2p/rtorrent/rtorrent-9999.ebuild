# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic git-r3

DESCRIPTION="BitTorrent Client using libtorrent"
HOMEPAGE="https://rakshasa.github.io/rtorrent/"
EGIT_REPO_URI="https://github.com/rakshasa/${PN}.git"
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
	default
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
		$(use_with xmlrpc xmlrpc-c)
}

src_install() {
	default

	if use daemon; then
		newinitd "${FILESDIR}/rtorrentd.init" rtorrentd
		newconfd "${FILESDIR}/rtorrentd.conf" rtorrentd
	fi
}
