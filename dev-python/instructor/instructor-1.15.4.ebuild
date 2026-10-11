# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Structured outputs for LLMs (OpenAI, Anthropic, Mistral, more)"
HOMEPAGE="https://github.com/jxnl/instructor https://python.useinstructor.com/"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies mirror instructor 1.15.4 pyproject.toml [project].dependencies.
# Two upstream upper bounds relaxed to match what is already in tree
# (verified for instructor 1.17.0; same symbols resolve here):
#   rich<15    -> <16  (tree ships rich-15.0.0)
#   jiter<0.15 -> <1   (tree ships jiter-0.16.0)
RDEPEND="
	>=dev-python/aiohttp-3.9.1[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4
	>=dev-python/docstring-parser-0.16[${PYTHON_USEDEP}]
	<dev-python/docstring-parser-1
	>=dev-python/jinja2-3.1.4[${PYTHON_USEDEP}]
	<dev-python/jinja2-4
	>=dev-python/jiter-0.6.1[${PYTHON_USEDEP}]
	<dev-python/jiter-1
	>=dev-python/openai-2.0.0[${PYTHON_USEDEP}]
	<dev-python/openai-3
	>=dev-python/pydantic-2.8.0[${PYTHON_USEDEP}]
	<dev-python/pydantic-3
	>=dev-python/pydantic-core-2.18.0[${PYTHON_USEDEP}]
	<dev-python/pydantic-core-3
	>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
	<dev-python/requests-3
	>=dev-python/rich-13.7.0[${PYTHON_USEDEP}]
	<dev-python/rich-16
	>=dev-python/tenacity-8.2.3[${PYTHON_USEDEP}]
	<dev-python/tenacity-10
	>=dev-python/typer-0.9.0[${PYTHON_USEDEP}]
	<dev-python/typer-1
"

RESTRICT="test"
