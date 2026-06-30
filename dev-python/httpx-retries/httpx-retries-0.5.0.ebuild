# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )
inherit distutils-r1

DESCRIPTION="Retry policy plugin for httpx"
HOMEPAGE="https://github.com/sasseneg/httpx-retries"
# The PyPI sdist filename uses an underscore (httpx_retries) while the
# project name uses a hyphen (httpx-retries); pypi_sdist_url derives the
# filename from the project name and gets it wrong. Pin the URL directly.
SRC_URI="https://files.pythonhosted.org/packages/source/h/httpx-retries/httpx_retries-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/httpx[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
