# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
inherit python-single-r1

DESCRIPTION="MCP server for time and timezone conversion"
HOMEPAGE="https://github.com/modelcontextprotocol/servers/tree/main/src/time"
SRC_URI="https://files.pythonhosted.org/packages/ad/d9/fcc7f85f0cdcfa8da9c650439128dd72be21855a126b745f17cf43f24b11/mcp_server_time-${PV}-py3-none-any.whl"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		>=dev-python/mcp-1.28.1[${PYTHON_USEDEP}]
		<dev-python/mcp-2[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/tzdata-2024.2[${PYTHON_USEDEP}]
		>=dev-python/tzlocal-5.3.1[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

BDEPEND="app-arch/unzip"

src_unpack() {
	unzip -q "${DISTDIR}/${A}" -d "${S}" || die
}

src_install() {
	python_domodule mcp_server_time
	cat > "${T}/mcp-server-time" <<-EOF
	#!/usr/bin/env python
	from mcp_server_time import main
	main()
	EOF
	python_doscript "${T}/mcp-server-time"
	einstalldocs
}

pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/mcp-server-time\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
