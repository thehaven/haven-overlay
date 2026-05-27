# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 git-r3

DESCRIPTION="MCP server for Gemini DeepSearch — automated research agent"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/gemini-deepsearch-mcp"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/gemini-deepsearch-mcp.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

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
	>=dev-python/fastmcp-3.0.0[${PYTHON_USEDEP}]
	dev-python/fastapi[${PYTHON_USEDEP}]
	>=dev-python/langgraph-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/langchain-0.3.19[${PYTHON_USEDEP}]
	>=dev-python/langchain-google-genai-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/langgraph-sdk-0.1.57[${PYTHON_USEDEP}]
	dev-python/langgraph-cli[${PYTHON_USEDEP}]
	dev-python/langgraph-api[${PYTHON_USEDEP}]
	dev-python/google-genai[${PYTHON_USEDEP}]
	>=dev-python/google-ai-generativelanguage-0.6.18[${PYTHON_USEDEP}]
"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	distutils-r1_src_prepare

}

src_install() {
	distutils-r1_src_install
}

pkg_postinst() {
	elog "Set your Gemini API key before use:"
	elog "  export GEMINI_API_KEY='your-key-here'"
	elog ""
	elog "To override model defaults, set these environment variables:"
	elog "  QUERY_GENERATOR_MODEL='gemini-3.1-flash-lite'"
	elog "  WEB_SEARCH_MODEL='gemini-3.1-flash-lite'"
	elog "  REFLECTION_MODEL='gemini-3.1-flash-lite'"
	elog "  ANSWER_MODEL='gemini-3.1-pro-preview'"
	elog ""
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/gemini-deepsearch-mcp\","
	elog "      \"args\": [],"
	elog "      \"env\": {"
	elog "        \"GEMINI_API_KEY\": \"AIzaSy... (your key)\","
	elog "        \"QUERY_GENERATOR_MODEL\": \"gemini-3.1-flash-lite\","
	elog "        \"WEB_SEARCH_MODEL\": \"gemini-3.1-flash-lite\","
	elog "        \"REFLECTION_MODEL\": \"gemini-3.1-flash-lite\","
	elog "        \"ANSWER_MODEL\": \"gemini-3.1-pro-preview\""
	elog "      }"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"mcpServers\": {"
	elog "      \"${PN}\": {"
	elog "        \"command\": \"/usr/bin/gemini-deepsearch-mcp\","
	elog "        \"args\": [],"
	elog "        \"env\": {"
	elog "          \"GEMINI_API_KEY\": \"AIzaSy... (your key)\","
	elog "          \"QUERY_GENERATOR_MODEL\": \"gemini-3.1-flash-lite\","
	elog "          \"WEB_SEARCH_MODEL\": \"gemini-3.1-flash-lite\","
	elog "          \"REFLECTION_MODEL\": \"gemini-3.1-flash-lite\","
	elog "          \"ANSWER_MODEL\": \"gemini-3.1-pro-preview\""
	elog "        }"
	elog "      }"
	elog "    }"
}
