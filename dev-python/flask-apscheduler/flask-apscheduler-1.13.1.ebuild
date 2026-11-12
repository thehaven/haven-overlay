# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN=Flask-APScheduler
PYPI_NO_NORMALIZE=1
inherit distutils-r1 pypi

DESCRIPTION="Adds APScheduler support to Flask"
HOMEPAGE="https://github.com/viniciuschiele/flask-apscheduler"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/flask-3.0[${PYTHON_USEDEP}]
	>=dev-python/apscheduler-3.10[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.4.2[${PYTHON_USEDEP}]
"
