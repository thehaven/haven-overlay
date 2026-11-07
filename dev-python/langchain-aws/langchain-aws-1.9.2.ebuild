# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 pypi

DESCRIPTION="AWS integrations for LangChain"
HOMEPAGE="https://github.com/langchain-ai/langchain-aws"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/langchain-core[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
"
