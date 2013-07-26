# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

DESCRIPTION="Nagios plugin to poll Graphite"
HOMEPAGE="https://github.com/datacratic/check_graphite"
EGIT_REPO_URI="https://github.com/datacratic/check_graphite.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto /usr/lib64/nagios/plugins/

    doins ${WORKDIR}/${P}/check_graphite

    fowners -R root:nagios /usr/lib64/nagios/plugins
    fperms -R g+rwx /usr/lib64/nagios/plugins
    fperms -R u+rwx /usr/lib64/nagios/plugins
}
