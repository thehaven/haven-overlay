# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="office-powerpoint-mcp-server"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
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

src_prepare() {
	default

	# Upstream ships slide_layout_templates.json at the project root and lists
	# it in [tool.hatch.build.targets.wheel] only-include. utils/template_utils.py
	# (lines 197, 495) looks it up via os.path.join(dirname(__file__), ...), so
	# the runtime path is site-packages/utils/slide_layout_templates.json.
	# The pyproject.toml list also includes enhanced_slide_templates.json which
	# is not actually shipped in the tarball (hatch warns at build time).
	# Move the file to its expected runtime location, then prune both stale
	# entries from only-include (the existing "utils/" glob picks up the move).
	mv slide_layout_templates.json utils/slide_layout_templates.json || die
	sed -i \
		-e 's/, "slide_layout_templates.json"//g' \
		-e 's/, "enhanced_slide_templates.json"//g' \
		pyproject.toml || die
}

src_install() {
	distutils-r1_src_install
}
