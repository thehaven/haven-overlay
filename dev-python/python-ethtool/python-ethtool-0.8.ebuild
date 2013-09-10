# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils eutils

DESCRIPTION="Python bindings for the ethtool kernel interface"
HOMEPAGE="http://fedorapeople.org/cgit/dsommers/public_git/python-ethtool.git/"
SRC_URI="https://git.fedorahosted.org/cgit/python-ethtool.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libnl:1.1"
RDEPEND="${DEPEND}"
