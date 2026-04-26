# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 git-r3

DESCRIPTION="Universal MCP package manager and profile orchestrator"
HOMEPAGE="https://github.com/haven/mcp-forge"
EGIT_REPO_URI="file:///storage/home/haven/projects/personal/mcp-forge"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest
