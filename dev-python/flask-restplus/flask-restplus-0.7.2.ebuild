# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN="flask-restplus"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Flask-RestPlus provides syntaxic sugar, helpers and automatically generated Swagger documentation on top of Flask-Restful."
HOMEPAGE="https://github.com/noirbizarre/flask-restplus"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-python/flask-0.09[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
    rm -r tests
    distutils-r1_python_prepare_all
}
