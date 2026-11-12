# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="x25519"
inherit distutils-r1 pypi

DESCRIPTION="x25519 Python package"
HOMEPAGE="https://github.com/1ocalhost/x25519"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

