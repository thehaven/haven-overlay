# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="A flexible utility for flattening and unflattening dict-like objects in Python."
HOMEPAGE="https://github.com/ianlini/flatten-dict"


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
