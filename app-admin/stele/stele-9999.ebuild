# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 git-r3

DESCRIPTION="Deterministic multi-format content conversion tool"
HOMEPAGE="https://github.com/haven/stele"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/stele.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
RESTRICT="network-sandbox"

IUSE="mcp pdf"

# mcp 2.x removed mcp.server.fastmcp (FastMCP moved to
# mcp.server.mcpserver); 1.29.x is not packaged in this overlay.
RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/markdown-it-py[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/curl-cffi[${PYTHON_USEDEP}]
	dev-python/defusedxml[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	mcp? (
		>=dev-python/mcp-1.28.1[${PYTHON_USEDEP}]
		<dev-python/mcp-2[${PYTHON_USEDEP}]
	)
	pdf? ( dev-python/marker-pdf[${PYTHON_USEDEP}] )
"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest
