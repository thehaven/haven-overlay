# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="New version checker for software releases"
HOMEPAGE="https://github.com/lilydjwg/nvchecker https://pypi.org/project/nvchecker/"
SRC_URI="https://github.com/lilydjwg/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="htmlparser jq pypi rpmrepo vercmp"

RDEPEND="
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
	>=dev-python/tornado-6[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' python3_10)
	htmlparser? ( dev-python/lxml[${PYTHON_USEDEP}] )
	jq? ( dev-python/jq[${PYTHON_USEDEP}] )
	pypi? ( dev-python/packaging[${PYTHON_USEDEP}] )
	rpmrepo? (
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
	)
	vercmp? ( dev-python/pyalpm[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
