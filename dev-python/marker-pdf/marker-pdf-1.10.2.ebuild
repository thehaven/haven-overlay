# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 pypi

DESCRIPTION="Convert documents to markdown with high speed and accuracy"
HOMEPAGE="https://github.com/vikun-khanna/marker"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# marker-pdf has many dependencies, for a basic ebuild we'll list the core ones
RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
"
