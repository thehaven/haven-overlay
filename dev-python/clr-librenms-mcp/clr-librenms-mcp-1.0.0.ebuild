# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="MCP server for LibreNMS network monitoring"
HOMEPAGE="https://github.com/clearminds/clr-librenms-mcp"

# Upstream pins fastmcp>=2.14.0,<3, but the middleware it uses only exists in
# fastmcp 2.x. The bundled patch drops the cosmetic ToolValidationMiddleware
# so the server runs on the overlay's fastmcp 3.x/4.x (15 other ebuilds
# require >=3.0.0, so pinning 2.14.x is not an option).
PATCHES=( "${FILESDIR}/clr-librenms-mcp-1.0.0-fastmcp3-compat.patch" )

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
# Annotation tests need running LibreNMS + HTTP mocking; not runnable in sandbox.
RESTRICT="test"

RDEPEND="
	>=dev-python/fastmcp-3.4.2[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2[${PYTHON_USEDEP}]
	>=dev-python/pydantic-settings-2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/${PN}\"],"
	elog "      \"enabled\": true"
	elog "    }"
	elog ""
	elog "The server requires LibreNMS credentials at startup:"
	elog "  LIBRENMS_URL and LIBRENMS_TOKEN (env vars), or"
	elog "  ~/.config/librenms/credentials.json ({\"url\": ..., \"token\": ...})"
	elog "Optional: LIBRENMS_READ_ONLY=true for read-only mode."
}
