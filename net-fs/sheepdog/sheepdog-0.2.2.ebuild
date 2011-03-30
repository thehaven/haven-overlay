# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit bash-completion

DESCRIPTION="Distributed Storage System for KVM."
HOMEPAGE="http://www.osrg.net/sheepdog/"
SRC_URI="mirror://sourceforge/sheepdog/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-cluster/corosync
	|| ( >=app-emulation/qemu-kvm-0.13 >=app-emulation/qemu-0.13 app-emulation/qemu-kvm-spice )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	# default make install is stupid
	dosbin collie/collie sheep/sheep
	doman man/*.8
	dodoc README
	dobashcompletion script/bash_completion_collie ${PN}-collie
	keepdir /var/lib/sheepdog
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}

pkg_postinst() {
	elog "Make sure that the storage path (default: '/var/lib/sheepdog')"
	elog "lies on a filesystem with extended attributes (xattr) support."
	elog ""
	elog "Once installed follow the wiki for guidlines on setup:"
	elog "http://wiki.qemu.org/Features/Sheepdog/Getting_Started#Setup_Sheepdog"
}
