# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="CLI for CrewAI (scaffold, run, deploy, manage AI agent crews)"
HOMEPAGE="https://github.com/crewAIInc/crewAI"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies mirror crewai-cli 1.15.26 pyproject.toml [project].dependencies.
# The == / ~= / >= / < bounds are translated to Gentoo atoms verbatim.
RDEPEND="
	=dev-python/crewai-core-1.15.26*
	>=dev-python/click-8.1.7[${PYTHON_USEDEP}]
	<dev-python/click-9
	>=dev-python/pydantic-2.11.9[${PYTHON_USEDEP}]
	<dev-python/pydantic-2.13
	>=dev-python/pydantic-settings-2.14.2[${PYTHON_USEDEP}]
	<dev-python/pydantic-settings-3
	>=dev-python/cryptography-42.0[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-2.13.0[${PYTHON_USEDEP}]
	<dev-python/pyjwt-3
	>=dev-python/tomli-w-1.1.0[${PYTHON_USEDEP}]
	<dev-python/tomli-w-1.2
	>=dev-python/packaging-23.0[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-1.2.2[${PYTHON_USEDEP}]
	<dev-python/python-dotenv-2
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	<dev-python/httpx-0.29
	>=dev-python/textual-7.5.0[${PYTHON_USEDEP}]
	>=dev-python/uv-0.11.6[${PYTHON_USEDEP}]
	<dev-python/uv-0.12
"

# Upstream test suite requires live API access and remote services
RESTRICT="test"

# CrewAI CLI ships a `crewai` console script
# (pyproject.toml [project.scripts]: crewai = "crewai_cli.cli:crewai")
# distutils-r1 installs it under /usr/bin/crewai; nothing else in this
# overlay claims that path.
