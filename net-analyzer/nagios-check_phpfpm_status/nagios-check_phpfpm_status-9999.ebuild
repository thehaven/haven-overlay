# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2

DESCRIPTION="Nagios check for php-fpm status report"
HOMEPAGE="https://github.com/regilero/check_phpfpm_status"
EGIT_REPO_URI="https://github.com/regilero/check_phpfpm_status.git"

LICENSE=""
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
    #Fix incorrect libexec path in plugin:
    sed -i 's/\/usr\/local\/nagios\/libexec/\/usr\/lib64\/nagios\/plugins/g' ${WORKDIR}/${P}/check_phpfpm_status.pl

	insinto /usr/lib64/nagios/plugins/

    doins ${WORKDIR}/${P}/check_phpfpm_status.pl

    fowners -R root:nagios /usr/lib64/nagios/plugins
    fperms -R g+rwx /usr/lib64/nagios/plugins
    fperms -R u+rwx /usr/lib64/nagios/plugins
}
