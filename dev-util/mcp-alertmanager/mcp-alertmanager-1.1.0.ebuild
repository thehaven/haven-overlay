# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_12 )

inherit distutils-r1

DESCRIPTION="MCP server for Prometheus Alertmanager"
HOMEPAGE="https://github.com/ntk148v/alertmanager-mcp-server"
SRC_URI="https://github.com/ntk148v/alertmanager-mcp-server/archive/refs/tags/v${PV}.tar.gz -> alertmanager-mcp-server-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/alertmanager-mcp-server-${PV}"

distutils_enable_tests pytest
