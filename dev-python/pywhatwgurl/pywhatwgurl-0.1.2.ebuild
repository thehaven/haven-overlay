# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="pywhatwgurl"
inherit distutils-r1 pypi

BDEPEND="dev-python/hatch-vcs"

DESCRIPTION="Pure Python implementation of the WHATWG URL Standard"
HOMEPAGE="https://github.com/pywhatwgurl/pywhatwgurl"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/idna[${PYTHON_USEDEP}]"
