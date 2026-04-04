# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8
PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="PyroCore - Python Torrent Tools Core Package"
HOMEPAGE="http://code.google.com/p/pyroscope/"
SRC_URI="https://pypi.python.org/packages/source/p/pyrocore/${P}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""



