# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Extract the top level domain (TLD) from the URL"
HOMEPAGE="https://github.com/barseghyanartur/tld"

LICENSE="GPL-2.0-only" # Actually LGPL-2.1 or MPL-1.1 based on github, but PyPI says GPL 2.0
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
