# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit distutils eutils git-2

DESCRIPTION="Ready made monitoring packs for Nagios"
HOMEPAGE="https://github.com/opinkerfi/okconfig"
EGIT_REPO_URI="https://github.com/opinkerfi/okconfig.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/paramiko
		net-analyzer/nagios
		>net-analyzer/pynag-0.4.6"
RDEPEND="${DEPEND}"
