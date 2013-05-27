# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-2

DESCRIPTION="The experimental SPDY protocol version 2 and 3 implementation in C"
HOMEPAGE="http://spdylay.sourceforge.net/"
EGIT_REPO_URI="git://github.com/tatsuhiro-t/spdylay.git"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
		>=sys-devel/autoconf-2.68
		>=dev-libs/openssl-1.0.1e-r1
		>=dev-util/cunit-2.1
		>=dev-libs/libxml2-2.7.7
		>=dev-libs/libevent-2.0.8
		>=sys-libs/zlib-1.2.3
"
RDEPEND="${DEPEND}"


src_configure() {
	autoreconf -i
	automake
	autoconf
}

src_compile() {
    if [ -x ./configure ]; then
        econf
    fi
    if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
	        emake || die "emake failed"
    fi
}

src_install() {
    emake DESTDIR="${D}" install || die "Install failed"

	insinto /etc/init.d/
	newins "${FILESDIR}/shrpx.init" "shrpx"
	insinto /etc/conf.d/
	newins "${FILESDIR}/shrpx.conf" "shrpx"
}
