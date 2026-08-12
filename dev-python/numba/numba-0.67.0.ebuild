# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Just-in-time compiler for NumPy functions via LLVM"
HOMEPAGE="https://numba.pydata.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=dev-python/llvmlite-0.46[${PYTHON_USEDEP}]
"
