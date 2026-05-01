# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 git-r3 systemd

DESCRIPTION="Dynamic MCP gateway: just-in-time tool mounting and policy-aware proxy"
HOMEPAGE="https://github.com/haven/mcp-mesh"
EGIT_REPO_URI="file:///storage/home/haven/projects/personal/mcp-mesh"
EGIT_COMMIT="v0.14.1"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

RDEPEND="
	acct-user/mcp
	dev-python/fastapi[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/bcrypt[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all
	systemd_dounit "${FILESDIR}"/mcp-mesh.service
	newconfd "${FILESDIR}"/mcp-mesh.confd mcp-mesh
}

distutils_enable_tests pytest
