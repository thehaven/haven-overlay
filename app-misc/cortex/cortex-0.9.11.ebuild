# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 git-r3 systemd

DESCRIPTION="Vault knowledge agent — search, RAG, and ingestion for Obsidian"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/ai-ml/cortex"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/ai-ml/cortex.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/cortex
	acct-user/cortex
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pydantic-settings[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/tiktoken[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/starlette[${PYTHON_USEDEP}]
	dev-python/uvicorn[${PYTHON_USEDEP}]
	dev-python/structlog[${PYTHON_USEDEP}]
	dev-python/sqlite-vec[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/watchfiles[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	insinto /etc/cortex
	doins "${FILESDIR}/cortex.yaml"
	systemd_dounit "${FILESDIR}/cortex.service"
	systemd_dounit "${FILESDIR}/cortex-mcp.service"
	if [[ -f docs/cortex.1 ]]; then
		doman docs/cortex.1
	fi
}

pkg_postinst() {
	elog "Cortex is installed. It runs in one of two ways."
	elog ""
	elog "== 1. Single-client MCP server (stdio — the default) =="
	elog "Point one MCP client at the 'cortex' binary with the 'mcp' arg:"
	elog "  Gemini CLI (~/.gemini/settings.json):"
	elog "    \"cortex\": { \"command\": \"/usr/bin/cortex\", \"args\": [\"mcp\"] }"
	elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
	elog "    \"cortex\": { \"command\": \"/usr/bin/cortex\", \"args\": [\"mcp\"] }"
	elog ""
	elog "== 2. Shared host service for an MCP gateway (streamable-HTTP) =="
	elog "Use this when a gateway (e.g. mcp-mesh) must reach Cortex as the"
	elog "vault owner rather than as its own unprivileged service user."
	elog ""
	elog "  a) Create the shared bearer token. Without it the loopback port"
	elog "     would let ANY local user read the vault and write notes."
	elog "       install -d -m 0755 /etc/cortex"
	elog "       echo \"CORTEX_MCP_TOKEN=\$(openssl rand -hex 32)\" > /etc/cortex/cortex-mcp.env"
	elog "       chmod 0640 /etc/cortex/cortex-mcp.env"
	elog "       chown root:<gateway-group> /etc/cortex/cortex-mcp.env"
	elog ""
	elog "  b) Review then start the service. It runs as the vault owner:"
	elog "       systemctl enable --now cortex-mcp.service"
	elog "     The shipped unit assumes:"
	elog "       User=haven  Group=haven"
	elog "       CORTEX_VAULT_ROOT=/storage/home/haven/.obsidian/Proofpoint"
	elog "       bind 127.0.0.1:8771"
	elog "     Edit /usr/lib/systemd/system/cortex-mcp.service (User, Group,"
	elog "     paths, port) or override with Environment= lines / a drop-in"
	elog "     under /etc/systemd/system/cortex-mcp.service.d/ if your vault"
	elog "     owner or paths differ, then: systemctl daemon-reload"
	elog ""
	elog "  c) Register Cortex with the gateway as a REMOTE backend:"
	elog "       httpUrl: http://127.0.0.1:8771/mcp"
	elog "       http_transport: streamable-http"
	elog "       headers: { Authorization: \"Bearer \${CORTEX_MCP_TOKEN}\" }"
	elog ""
	elog "  Verify:  curl -sf http://127.0.0.1:8771/health"
	elog "  Docs:    man cortex | cortex mcp --help"
	elog "           /usr/share/doc/${PF}/README.md (MCP over streamable-HTTP)"
}
