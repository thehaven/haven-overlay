# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

EAPI="4"
RESTRICT="mirror"

DESCRIPTION="Scripts to support compressed swap devices or ramdisks with zram"
HOMEPAGE="http://www.mathematik.uni-wuerzburg.de/~vaeth/download/index.html"
SRC_URI="http://www.mathematik.uni-wuerzburg.de/~vaeth/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh-completion"

src_install() {
	dosbin zram-init
	newinitd zram-init.initd zram-init
	newconfd zram-init.confd zram-init
	if use zsh-completion
	then	insinto /usr/share/zsh/site-functions
		doins _zram-init
	fi
}

pkg_postinst() {
	elog
	elog "To use zram, activate it in your kernel and add it to default runlevel:"
	elog "rc-update add zram default"
	elog "Then edit: /etc/conf.d/zram-init"
	elog
	elog "For more information:"
	elog "See the gentoo wiki: http://en.gentoo-wiki.com/wiki/Zram_disks"
	elog "Or the google code page: https://code.google.com/p/compcache"
	elog
}
