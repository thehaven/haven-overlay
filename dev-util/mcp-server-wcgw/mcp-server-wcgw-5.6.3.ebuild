# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_PN="wcgw"
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_SINGLE_IMPL=1
inherit distutils-r1 pypi

DESCRIPTION="MCP server for shell command execution (wcgw)"
HOMEPAGE="https://github.com/rusiaaman/wcgw"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

python_test() {
	${EPYTHON} -c "from wcgw.client.mcp_server import main; print('Import successful')" || die "Import test failed"
}

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/anthropic[${PYTHON_USEDEP}]
		dev-python/fastapi[${PYTHON_USEDEP}]
		>=dev-python/mcp-1.23.0[${PYTHON_USEDEP}]
		dev-python/openai[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pydantic[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
		sci-ml/tokenizers[${PYTHON_SINGLE_USEDEP}]
		dev-python/typer[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
		dev-python/syntax-checker[${PYTHON_USEDEP}]
		dev-python/wcmatch[${PYTHON_USEDEP}]
		dev-python/pygit2[${PYTHON_USEDEP}]
	')
"

src_prepare() {
	distutils-r1_src_prepare
	# Option C: Resilience Patch (via sed)
	# 1. Increase timeout from 5s to 10s
	sed -i 's/timeout: float = 5/timeout: float = 10/' src/wcgw/client/bash_state/bash_state.py || die
	# 2. Force deterministic PS1
	sed -i '/"PAGER": "cat",/a \        "PS1": "◉ \\w──➤ ",' src/wcgw/client/bash_state/bash_state.py || die
}

pkg_postinst() {
	elog "To add this MCP server to your AI clients:"
	elog ""
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/wcgw\","
	elog "      \"args\": [\"--shell\", \"/bin/bash\"]"
	elog "    }"
	elog ""
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"${PN}\": {"
	elog "      \"command\": \"/usr/bin/wcgw\","
	elog "      \"args\": [\"--shell\", \"/bin/bash\"]"
	elog "    }"
	elog ""
	elog "  OpenCode (~/.config/opencode/opencode.json):"
	elog "    \"${PN}\": {"
	elog "      \"type\": \"local\","
	elog "      \"command\": [\"/usr/bin/wcgw\", \"--shell\", \"/bin/bash\"],"
	elog "      \"enabled\": true"
	elog "    }"
}
