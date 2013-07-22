# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit distutils eutils git-2

DESCRIPTION="Ready made monitoring packs for Nagios"
HOMEPAGE="http://okconfig.org/"
EGIT_REPO_URI="https://github.com/opinkerfi/okconfig.git"
REVISION=${PR/r/-}
EGIT_COMMIT=${P}${REVISION}

LICENSE=""
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND="dev-python/paramiko
		net-analyzer/nagios
		>net-analyzer/pynag-0.4.6"
RDEPEND="${DEPEND}"

pkg_postinst() {
    elog "Run the following to setup okconfig:"
    elog ""
	elog "okconfig init"
	elog "okconfig verify"
}
