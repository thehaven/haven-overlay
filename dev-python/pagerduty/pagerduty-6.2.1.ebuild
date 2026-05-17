# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_PN="pagerduty"
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Python client for PagerDuty API"
HOMEPAGE="https://github.com/PagerDuty/pdpyras"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	# Patch uv_build to hatchling.build
	sed -i 's/build-backend = "uv_build"/build-backend = "hatchling.build"/' pyproject.toml || die
}
