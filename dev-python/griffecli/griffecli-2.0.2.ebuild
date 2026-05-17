# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="griffecli"
inherit distutils-r1 pypi

BDEPEND="dev-python/uv-dynamic-versioning[${PYTHON_USEDEP}]"

DESCRIPTION="griffecli Python package"
HOMEPAGE="https://pypi.org/project/griffecli/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/griffelib[${PYTHON_USEDEP}]
"
