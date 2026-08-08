# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 pypi

DESCRIPTION="Extract structured confidence scores from LLM token logprobs"
HOMEPAGE="https://pypi.org/project/llm-structured-confidence/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# test_e2e.py calls live LLM APIs (network + credentials); unit tests need
# pydantic and additional optional extras.
RESTRICT="test"

RDEPEND=">=dev-python/lark-1.1[${PYTHON_USEDEP}]"
