# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="fastapi-cli"
inherit distutils-r1 pypi

DESCRIPTION="fastapi-cli Python package"
HOMEPAGE="https://github.com/fastapi/fastapi-cli"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/rich-toolkit[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
"
