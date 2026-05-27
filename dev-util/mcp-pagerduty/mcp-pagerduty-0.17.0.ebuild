# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Official PagerDuty MCP server"
HOMEPAGE="https://github.com/PagerDuty/pagerduty-mcp-server"
SRC_URI="https://github.com/PagerDuty/pagerduty-mcp-server/archive/refs/heads/main.tar.gz -> mcp-pagerduty-main.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

python_test() {
	# Auto-generated import check
	local mod candidates
	# Normalize PN by replacing - with _
	local norm_pn="${PN//-/_}"
	# Strip mcp-server- and mcp- prefixes
	local suffix="${PN#mcp-server-}"
	suffix="${suffix#mcp-}"
	local norm_suffix="${suffix//-/_}"
	
	candidates=(
		"${norm_pn}"
		"mcp_server_${norm_suffix}"
		"${norm_suffix}"
	)
	
	for mod in "${candidates[@]}"; do
		einfo "Checking import of ${mod}..."
		if ${EPYTHON} -c "import ${mod}" 2>/dev/null; then
			einfo "✅ Import successful: ${mod}"
			return 0
		fi
	done
	die "❌ Import test failed: none of the candidates (${candidates[*]}) could be imported"
}

RDEPEND="
	dev-python/pagerduty[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
"

S="${WORKDIR}/pagerduty-mcp-server-main"

src_prepare() {
	distutils-r1_src_prepare
	# Patch uv_build to hatchling.build if present
	if [ -f pyproject.toml ]; then
		sed -i 's/build-backend = "uv_build"/build-backend = "hatchling.build"/' pyproject.toml || die
	fi
}

python_compile() {
	distutils-r1_python_compile
	# Remove stray top-level files from build directory
	find "${BUILD_DIR}"/install -name "tests" -type d -exec rm -rf {} + || :
	find "${BUILD_DIR}"/install -name "scripts" -type d -exec rm -rf {} + || :
}
