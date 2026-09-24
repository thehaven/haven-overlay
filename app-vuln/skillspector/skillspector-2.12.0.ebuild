# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Security scanner for AI agent skills"
HOMEPAGE="https://github.com/NVIDIA/SkillSpector"

SRC_URI="https://github.com/NVIDIA/SkillSpector/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

S="${WORKDIR}/SkillSpector-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="mcp"

# upstream pins typer<0.24 because typer>=0.24 needs click>=8.2.1 which
# conflicts with semgrep's click 8.1.x pin. semgrep is not a dependency
# here and only typer 0.27.x is available, so the upper bound is dropped.
# upstream pins regex==2026.5.9; only date-versioned releases 2026.7.19+
# are packaged. regex keeps a stable API across these, so the exact pin is
# relaxed to the upstream lower bound.
# mcp extra (skillspector mcp subcommand): upstream pins mcp>=1.29,<2.0.
# mcp 2.x removed mcp.server.fastmcp (FastMCP moved to
# mcp.server.mcpserver), so the upper bound is a hard requirement.
# 1.29.x is not packaged in this overlay; 1.28.1 is verified working.
RDEPEND="
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/langchain-anthropic[${PYTHON_USEDEP}]
	dev-python/langchain-aws[${PYTHON_USEDEP}]
	dev-python/langchain-core[${PYTHON_USEDEP}]
	dev-python/langchain-openai[${PYTHON_USEDEP}]
	dev-python/langgraph[${PYTHON_USEDEP}]
	dev-python/langsmith[${PYTHON_USEDEP}]
	dev-python/openai[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pywhatwgurl[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/yara-python[${PYTHON_USEDEP}]
	mcp? (
		>=dev-python/mcp-1.28.1[${PYTHON_USEDEP}]
		<dev-python/mcp-2[${PYTHON_USEDEP}]
	)
"

src_install() {
	distutils-r1_src_install
	# distutils-r1 installs console scripts through python-exec:
	# /usr/bin/skillspector is a symlink to the python-exec2 dispatcher,
	# dangling inside ${ED} (the binary ships with dev-lang/python-exec).
	[[ -L "${ED}/usr/bin/skillspector" ]] || die "console script not installed"
}

pkg_postinst() {
	elog "SkillSpector runs static analysis out of the box; the semantic"
	elog "(LLM) analyzers are skipped until a provider is configured."
	elog "Configuration is environment-variable only — see the upstream"
	elog "template:"
	elog "  https://github.com/NVIDIA/SkillSpector/blob/main/.env.example"
	elog ""
	elog "Common setups (place in /etc/env.d/99skillspector, then run"
	elog "env-update):"
	elog "  Ollama:     SKILLSPECTOR_PROVIDER=ollama"
	elog "              OLLAMA_BASE_URL=http://localhost:11434/v1"
	elog "  LiteLLM:    SKILLSPECTOR_PROVIDER=openai"
	elog "              OPENAI_API_KEY=<any>"
	elog "              OPENAI_BASE_URL=http://127.0.0.1:4000/v1"
	elog "  OpenRouter: SKILLSPECTOR_PROVIDER=openai"
	elog "              OPENAI_API_KEY=<sk-or-...>"
	elog "              OPENAI_BASE_URL=https://openrouter.ai/api/v1"
	elog "              SKILLSPECTOR_MODEL=<vendor>/<model>"
	elog ""
	elog "With USE=mcp the 'skillspector mcp' subcommand serves the scanner"
	elog "over MCP (stdio or http). Note: semantic analyzers use structured"
	elog "output, which some local models do not support."
}
