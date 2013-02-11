# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="NXLOG is a universal log collector and forwarder supporting
different platforms "
HOMEPAGE="http://nxlog-ce.sourceforge.net/"
SRC_URI="mirror://sourceforge/nxlog-ce/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_postinst() {
    elog
	elog "See the nxlog reference manual for configuration options."
	elog
	elog "Located in: /usr/share/doc/nxlog-ce/ or online at:"
	elog "http://nxlog.org/nxlog-docs/en/nxlog-reference-manual.html"
    elog
}
