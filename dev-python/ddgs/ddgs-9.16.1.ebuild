# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Dux Distributed Global Search metasearch library"
HOMEPAGE="
	https://github.com/deedy5/ddgs
	https://pypi.org/project/ddgs/
"
SRC_URI="https://files.pythonhosted.org/packages/source/d/ddgs/ddgs-${PV}.tar.gz"
S="${WORKDIR}/ddgs-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

# Upstream core runtime deps. httpx optional features (brotli, http2,
# socks) are pulled in via their Gentoo packages (brotlicffi, h2, socksio),
# not USE-deps on httpx itself — httpx ships no such USE flags.
RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/primp[${PYTHON_USEDEP}]
	dev-python/fake-useragent[${PYTHON_USEDEP}]
	dev-python/brotlicffi[${PYTHON_USEDEP}]
	dev-python/h2[${PYTHON_USEDEP}]
	dev-python/socksio[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "MCP server integration" dev-python/mcp
	optfeature "FastAPI HTTP API"       "dev-python/fastapi dev-python/uvicorn"
}
