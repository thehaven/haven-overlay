# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 pypi

DESCRIPTION="Automated semantic versioning and changelog generation for Python projects"
HOMEPAGE="https://python-semantic-release.readthedocs.io/"
SRC_URI="https://github.com/python-semantic-release/python-semantic-release/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/gitpython[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${PV}"
