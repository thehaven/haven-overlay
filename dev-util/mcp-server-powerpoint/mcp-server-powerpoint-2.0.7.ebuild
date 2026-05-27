# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="office-powerpoint-mcp-server"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for PowerPoint"
HOMEPAGE="https://pypi.org/project/office-powerpoint-mcp-server/"

LICENSE="MIT"

RDEPEND="
	dev-python/fonttools[${PYTHON_USEDEP}]
	>=dev-python/mcp-1.8.0[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/python-pptx[${PYTHON_USEDEP}]
"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	distutils-r1_src_install

	# Fix broken import resolution — upstream's module layout
	# uses bare 'import utils' which fails. Add sys.path.
	python_foreach_impl python_fix_shebang -q \
		"${ED}/usr/lib/python-exec/${EPYTHON}/ppt_mcp_server"

	for wrapper in $(find "${ED}" -name 'ppt_mcp_server' -path '*/python-exec/*'); do
		local pyver=$(basename $(dirname "$wrapper"))
		local site="/usr/lib/${pyver}/site-packages/office_powerpoint_mcp_server"
		sed -i "3a\\
import sys; sys.path.insert(0, \\"${site}\\")\\
from office_powerpoint_mcp_server.ppt_mcp_server import main" "$wrapper"
		# Remove the broken original import
		sed -i '/^from ppt_mcp_server import main/d' "$wrapper"
	done
}
