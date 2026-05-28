# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="langchain-google-genai"
inherit distutils-r1 pypi

DESCRIPTION="langchain-google-genai Python package"
HOMEPAGE="https://docs.langchain.com/oss/python/integrations/providers/google"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/filetype[${PYTHON_USEDEP}]
	dev-python/google-genai[${PYTHON_USEDEP}]
	dev-python/langchain-core[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
"
