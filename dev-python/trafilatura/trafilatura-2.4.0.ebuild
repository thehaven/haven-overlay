# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Python library and command-line tool to drain the Web"
HOMEPAGE="https://github.com/adbar/trafilatura"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-3.4.0[${PYTHON_USEDEP}]
	>=dev-python/courlan-1.3.2[${PYTHON_USEDEP}]
	>=dev-python/htmldate-1.9.2[${PYTHON_USEDEP}]
	>=dev-python/justext-3.0.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-5.3.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.26[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
