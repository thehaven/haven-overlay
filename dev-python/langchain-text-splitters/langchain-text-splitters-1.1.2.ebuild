# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_PN="langchain_text_splitters"
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="LangChain text splitting utilities"
HOMEPAGE="https://docs.langchain.com/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/langchain-core-1.2.31[${PYTHON_USEDEP}]
	<dev-python/langchain-core-2.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
