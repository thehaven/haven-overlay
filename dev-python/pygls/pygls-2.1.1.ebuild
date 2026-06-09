# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="A pythonic generic language server (pronounced like 'pie glass')"
HOMEPAGE="https://github.com/openlawlibrary/pygls"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/cattrs[${PYTHON_USEDEP}]
	dev-python/lsprotocol[${PYTHON_USEDEP}]
"
