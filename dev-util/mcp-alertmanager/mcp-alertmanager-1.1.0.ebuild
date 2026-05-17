# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

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

src_prepare() {
	distutils-r1_src_prepare
	# Patch uv_build to hatchling.build if present
	if [ -f pyproject.toml ]; then
		sed -i 's/build-backend = "uv_build"/build-backend = "hatchling.build"/' pyproject.toml || die
	fi
}


pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/alertmanager-mcp\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/alertmanager-mcp\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/alertmanager-mcp\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
