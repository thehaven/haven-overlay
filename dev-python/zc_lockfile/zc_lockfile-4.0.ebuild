# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="zc.lockfile"
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Basic inter-process locks"
HOMEPAGE="https://github.com/zopefoundation/zc.lockfile"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64"
