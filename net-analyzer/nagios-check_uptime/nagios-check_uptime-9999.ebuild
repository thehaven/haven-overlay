# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils git-2

DESCRIPTION="This Nagios plugin checks how long the system has been running."
HOMEPAGE="https://github.com/madrisan/nagios-plugins-uptime"
EGIT_REPO_URI="https://github.com/madrisan/nagios-plugins-uptime.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-devel/autoconf"
RDEPEND="${DEPEND}"


#src_unpack() {
#  einfo "Regenerating autotools files..."
#  autoconf || die "autoconf failed" 
#}

src_configure() {
  eautoreconf || die "autoconf failed"
  econf --libexecdir=/usr/lib64/nagios/plugins
}
