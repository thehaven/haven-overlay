# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Ebuild generated by g-pypi 0.2.2 (rev. 214)

EAPI=4

inherit distutils


DESCRIPTION="Manages ebuilds for Gentoo Linux using information from Python Package Index"
HOMEPAGE="https://github.com/iElectric/g-pypi"
SRC_URI="http://pypi.python.org/packages/source/g/g-pypi/${P}.tar.gz"
LICENSE="BSD-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="test doc"
DEPEND="dev-python/setuptools
	test? ( dev-python/nose )"
RDEPEND="dev-python/unittest2
	dev-python/jinja
	dev-python/yolk
	dev-python/pygments
	dev-python/configargparse
	>=dev-python/jaxml-3.02
	dev-python/metagen
	dev-python/sphinxcontrib-googleanalytics"

src_install() {
	distutils_src_install
	if use doc; then
		dodoc "${S}"/docs/*
	fi

}

src_test() {
	PYTHONPATH=. "${python}" setup.py nosetests || die "tests failed"
}

