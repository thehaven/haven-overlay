# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="dvc objects - filesystem and object-db level abstractions to use in dvc and dvc-data"
HOMEPAGE=""


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
