# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 git-r3

DESCRIPTION="Codex — terminal assistant for your personal knowledge base"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/better-brain"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/better-brain.git"

LICENSE="Proprietary"
SLOT="0"
KEYWORDS=""

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
