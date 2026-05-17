# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="MCP server wrapping jc for structured CLI output parsing"
HOMEPAGE="https://github.com/kellyjonbrazil/jc"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jc[${PYTHON_USEDEP}]
	>=dev-python/mcp-1.25.6[${PYTHON_USEDEP}]
"

RESTRICT="mirror"

src_unpack() {
	mkdir -p "${S}" || die
	cp "${FILESDIR}"/pyproject.toml "${S}"/ || die
	cp "${FILESDIR}"/jc_mcp.py "${S}"/ || die
}
