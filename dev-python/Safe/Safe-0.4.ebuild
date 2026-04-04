# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8
PYTHON_COMPAT=( python3_{12..14} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN="Safe"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Is your password safe? Safe will check the password strength for you."
HOMEPAGE="https://pypi.python.org/pypi/Safe"
SRC_URI="https://files.pythonhosted.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${MY_P}"
