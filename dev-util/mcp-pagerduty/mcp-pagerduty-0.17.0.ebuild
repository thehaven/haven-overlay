# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_12 )

inherit distutils-r1

DESCRIPTION="Official PagerDuty MCP server"
HOMEPAGE="https://github.com/PagerDuty/pagerduty-mcp-server"
SRC_URI="https://github.com/PagerDuty/pagerduty-mcp-server/archive/refs/heads/main.tar.gz -> mcp-pagerduty-main.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/pagerduty[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
"

S="${WORKDIR}/pagerduty-mcp-server-main"

python_compile() {
	distutils-r1_python_compile
	# Remove stray top-level files from build directory
	find "${BUILD_DIR}"/install -name "tests" -type d -exec rm -rf {} + || :
	find "${BUILD_DIR}"/install -name "scripts" -type d -exec rm -rf {} + || :
}
