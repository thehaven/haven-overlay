# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="types-PyYAML"
inherit distutils-r1 pypi

DESCRIPTION="Typing stubs for PyYAML"
HOMEPAGE="https://github.com/python/typeshed"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# no runtime dependencies (type stubs only)
