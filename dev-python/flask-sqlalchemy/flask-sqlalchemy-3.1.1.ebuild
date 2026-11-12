# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN=Flask-SQLAlchemy
inherit distutils-r1 pypi

DESCRIPTION="Adds SQLAlchemy support to your Flask application"
HOMEPAGE="https://palletsprojects.com/p/flask-sqlalchemy/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/flask-3.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-2.0.18[${PYTHON_USEDEP}]
"
