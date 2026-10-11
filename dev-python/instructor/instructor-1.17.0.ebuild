# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Structured outputs for LLMs (OpenAI, Anthropic, Mistral, and more)"
HOMEPAGE="https://github.com/jxnl/instructor https://python.useinstructor.com/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies mirror instructor 1.17.0 pyproject.toml [project].dependencies
# for python >= 3.10 (the markers excluding eval-type-backport, the py<3.10
# aiohttp/requests caps, and urllib3's py>=3.10 pin are not applicable to the
# python3_12 - 3.14 PYTHON_COMPAT below).
#
# Two upstream upper bounds are relaxed to match the versions already in the
# tree (verified: instructor 1.17.0 imports and its rich/jiter symbol set
# resolves against rich-15.0.0 and jiter-0.16.0):
#   * rich<15  -> <16   (tree ships rich-15.0.0)
#   * jiter<0.15 -> <1  (tree ships jiter-0.16.0)
# The deleted pydantic-core pin is redundant: dev-python/pydantic pulls the
# matching pydantic-core version.
RDEPEND="
	>=dev-python/aiohttp-3.14.3[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4
	>=dev-python/click-8.3.3[${PYTHON_USEDEP}]
	>=dev-python/docstring-parser-0.16[${PYTHON_USEDEP}]
	<dev-python/docstring-parser-1
	>=dev-python/idna-3.15[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3.1.4[${PYTHON_USEDEP}]
	<dev-python/jinja2-4
	>=dev-python/jiter-0.6.1[${PYTHON_USEDEP}]
	<dev-python/jiter-1
	>=dev-python/openai-2.0.0[${PYTHON_USEDEP}]
	<dev-python/openai-4
	>=dev-python/pydantic-2.8.0[${PYTHON_USEDEP}]
	<dev-python/pydantic-3
	>=dev-python/regex-2023.0.0[${PYTHON_USEDEP}]
	<dev-python/regex-2027
	>=dev-python/requests-2.33.0[${PYTHON_USEDEP}]
	<dev-python/requests-3
	>=dev-python/rich-13.7.0[${PYTHON_USEDEP}]
	<dev-python/rich-16
	>=dev-python/tenacity-8.2.3[${PYTHON_USEDEP}]
	<dev-python/tenacity-10
	>=dev-python/typer-0.9.0[${PYTHON_USEDEP}]
	<dev-python/typer-1
	>=dev-python/urllib3-2.7.0[${PYTHON_USEDEP}]
	<dev-python/urllib3-3
"

# Upstream test suite requires live provider API keys and network access
RESTRICT="test"
