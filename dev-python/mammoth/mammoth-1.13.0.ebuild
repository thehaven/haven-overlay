# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="mammoth"
inherit distutils-r1 pypi

DESCRIPTION="Convert Word documents (.docx) to clean HTML and Markdown"
HOMEPAGE="https://github.com/mwilliamson/python-mammoth"

LICENSE="BSD-2-Clause"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/cobble-0.1.3[${PYTHON_USEDEP}]
	<dev-python/cobble-0.2[${PYTHON_USEDEP}]
"
