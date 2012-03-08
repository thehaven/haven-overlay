# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Offline Filesystem to enable the use of an Network file system without a network connection or after a connection loss."
HOMEPAGE="http://sourceforge.net/projects/offlinefs/"
SRC_URI="mirror://sourceforge/offlinefs/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

COMMONDEPEND="dev-libs/confuse
	dev-libs/boost
	sys-libs/db
	sys-fs/fuse"

DEPEND="${COMMONDEPEND}
	sys-apps/attr"

RDEPEND="${COMMONDEPEND}
	kde? ( kde-base/kdialog )"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
