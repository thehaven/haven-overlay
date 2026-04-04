# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8
PYTHON_COMPAT=( python3_{12..14} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN="cssmin"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="*NO LONGER MAINTAINED*. A Python port of the YUI CSS compression algorithm."
HOMEPAGE="https://github.com/zacharyvoase/cssmin"
SRC_URI="https://files.pythonhosted.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P}"
