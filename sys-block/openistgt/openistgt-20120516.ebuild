# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/iscsitarget/iscsitarget-1.4.20.2.ebuild,v 1.4 2011/02/16 22:16:27 hwoarang Exp $
EAPI=4

inherit bsdmk eutils flag-o-matic

DESCRIPTION="FreeBSD port of the Open Source iSCSI target with professional features"
HOMEPAGE="http://sourceforge.net/projects/openistgt"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~x86_64 ~x86-fbsd"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

src_configure() {
	# Make it conform to Gentoo specific layout
	epatch "${FILESDIR}"/01-stop-rc.d-installation.patch || die
	epatch "${FILESDIR}"/02-fix-man-dir.patch || die
	# Fix some stupidity....
	econf --with-configdir="/etc" || die
}

src_compile() {
	mkmake || die
}

src_install() {
	einfo "Installing ${P}"
	mkinstall DESTDIR="${D}" LOCALBASE="/usr" MANDIR="/usr/share/man/man1" \
		NO_MANCOMPRESS= install || die

	newinitd "${FILESDIR}"/"${PN}"-init.d ietd || die
	newconfd "${FILESDIR}"/"${PN}"-conf.d ietd || die

	einfo "Installing ${P} documentation"

	dodoc doc/QUICKSTART etc/istgt.large.conf README* || die
}
