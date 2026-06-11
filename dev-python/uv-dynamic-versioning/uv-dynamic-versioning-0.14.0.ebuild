# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
PYPI_PN="uv-dynamic-versioning"
inherit distutils-r1 pypi

DESCRIPTION="uv-dynamic-versioning Python package"
HOMEPAGE="https://github.com/ninoseki/uv-dynamic-versioning/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/dunamai[${PYTHON_USEDEP}]
	dev-python/hatchling[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
"
