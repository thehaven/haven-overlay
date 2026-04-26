# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1 git-r3

DESCRIPTION="Deterministic multi-format content conversion tool"
HOMEPAGE="https://github.com/haven/stele"
EGIT_REPO_URI="file:///storage/home/haven/projects/personal/stele"
EGIT_COMMIT="v0.4.0"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

IUSE="mcp pdf"

RDEPEND="
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/markdown-it-py[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/curl-cffi[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/prometheus-client[${PYTHON_USEDEP}]
	mcp? ( dev-python/mcp[${PYTHON_USEDEP}] )
	pdf? ( dev-python/marker-pdf[${PYTHON_USEDEP}] )
"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest
