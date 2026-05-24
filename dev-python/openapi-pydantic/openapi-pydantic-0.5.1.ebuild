# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYPI_PN="openapi-pydantic"
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="OpenAPI (v3) models for Pydantic"
HOMEPAGE="https://pypi.org/project/openapi-pydantic/"
HOMEPAGE="https://pypi.org/project/openapi-pydantic/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pydantic-1.8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
