# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Convert documents to markdown with high speed and accuracy"
HOMEPAGE="https://pypi.org/project/marker-pdf/"
HOMEPAGE="https://pypi.org/project/marker-pdf/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/poetry-core[${PYTHON_USEDEP}]
"
