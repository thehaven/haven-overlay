# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="office-powerpoint-mcp-server"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
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
	# it in [tool.hatch.build.targets.wheel] only-include. Installed
	# utils/template_utils.py (lines 197, 495) resolves it via
	# dirname(dirname(__file__)) -> site-packages ROOT. Move the file into
	# utils/ (so the wheel installs it under the package, passing the
	# distutils-r1 stray-file guard) and copy it to the root in
	# python_install() below. enhanced_slide_templates.json is listed in
	# only-include but is not shipped in the tarball (hatch warns at build
	# time) - prune it.
	mv slide_layout_templates.json utils/slide_layout_templates.json || die
	sed -i \
		-e 's/, "slide_layout_templates.json"//g' \
		-e 's/, "enhanced_slide_templates.json"//g' \
		pyproject.toml || die

	# Installed utils/template_utils.py resolves the template via
	# dirname(dirname(__file__)) -> site-packages ROOT, but the file lives in
	# utils/. Point the lookup at dirname(__file__) so it finds the file the
	# wheel actually installs.
	sed -i \
		-e 's|os\.path\.dirname(os\.path\.dirname(os\.path\.abspath(__file__)))|os.path.dirname(os.path.abspath(__file__))|g' \
		utils/template_utils.py || die
}

python_install() {
	distutils-r1_python_install
}
