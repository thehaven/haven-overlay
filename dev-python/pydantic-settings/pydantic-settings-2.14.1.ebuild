# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="pydantic-settings"
inherit distutils-r1 pypi

DESCRIPTION="pydantic-settings Python package"
HOMEPAGE="https://github.com/pydantic/pydantic-settings"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/typing-inspection[${PYTHON_USEDEP}]
"
