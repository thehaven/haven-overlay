# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="awslabs-aws-api-mcp-server"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="MCP server for AWS API operations"
HOMEPAGE="https://github.com/search?q=mcp-server-aws"
HOMEPAGE="https://github.com/search?q=mcp-server-aws"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

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
	dev-python/python-frontmatter[${PYTHON_USEDEP}]
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/botocore[${PYTHON_USEDEP}]
	dev-python/fastmcp[${PYTHON_USEDEP}]
	dev-python/loguru[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

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
	elog "      \"command\": \"/usr/bin/awslabs.aws-api-mcp-server\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/awslabs.aws-api-mcp-server\","
	elog "      \"args\": []"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/awslabs.aws-api-mcp-server\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
