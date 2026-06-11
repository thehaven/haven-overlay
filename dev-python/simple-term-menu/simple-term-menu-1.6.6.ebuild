# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="A simple terminal menu for Python"
HOMEPAGE="https://github.com/IngoMeyer441/simple-term-menu"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# No tests in sdist
# distutils_enable_tests pytest
