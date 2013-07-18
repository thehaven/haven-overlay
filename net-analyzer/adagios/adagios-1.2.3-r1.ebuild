# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit distutils eutils git-2

DESCRIPTION="Web based Nagios configuration interface"
HOMEPAGE="http://adagios.org/"
EGIT_REPO_URI="https://github.com/opinkerfi/adagios.git"
REVISION=${PR/r/-}
EGIT_COMMIT=${P}${REVISION}

LICENSE=""
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND="net-analyzer/okconfig
		net-analyzer/pynag
		net-analyzer/pnp4nagios
		net-analyzer/mk-livestatus"
RDEPEND="${DEPEND}"
