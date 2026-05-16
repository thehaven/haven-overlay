# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 pypi

DESCRIPTION="Python parser for human readable dates"
HOMEPAGE="https://github.com/scrapinghub/dateparser"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/python-dateutil-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2024.2[${PYTHON_USEDEP}]
	>=dev-python/regex-2024.9.11[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-0.2[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
