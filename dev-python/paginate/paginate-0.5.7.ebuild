# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Divides large result sets into pages for easier browsing"
HOMEPAGE="
	https://github.com/Signum/paginate
	https://pypi.org/project/paginate/
"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

distutils_enable_tests pytest
