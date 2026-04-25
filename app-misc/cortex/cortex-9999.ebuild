# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 git-r3

DESCRIPTION="Vault knowledge agent — search, RAG, and ingestion for Obsidian"
HOMEPAGE="https://github.com/PFPT-Internal/salman-cortex"
EGIT_REPO_URI="https://github.com/PFPT-Internal/salman-cortex.git"

KEYWORDS=""
LICENSE="Proprietary"
SLOT="0"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pydantic-settings[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tiktoken[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
