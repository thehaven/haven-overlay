# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 git-r3 systemd

DESCRIPTION="Vault knowledge agent — search, RAG, and ingestion for Obsidian"
HOMEPAGE="ssh://git@gitlab-ee.thehavennet.org.uk/ai-ml/cortex"
EGIT_REPO_URI="file:///storage/home/haven/projects/services/cortex"

KEYWORDS="~amd64"
LICENSE="Proprietary"
SLOT="0"

RDEPEND="
        acct-group/cortex
        acct-user/cortex
        dev-python/pydantic[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/pydantic-settings[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/typer[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/rich[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/pyyaml[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/tiktoken[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/httpx[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/mcp[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/structlog[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/sqlite-vec[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/watchfiles[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
        dev-python/psutil[python_targets_python3_12(-)?,python_targets_python3_13(-)?,python_targets_python3_14(-)?]
"

distutils_enable_tests pytest

src_install() {
        distutils-r1_src_install
        insinto /etc/cortex
        doins "${FILESDIR}/cortex.yaml"
        systemd_dounit "${FILESDIR}/cortex.service"
        if [[ -f docs/cortex.1 ]]; then
                doman docs/cortex.1
        fi
}

pkg_postinst() {
        elog "To add this MCP server to your AI clients:"
        elog ""
        elog "  Gemini CLI (~/.gemini/settings.json):"
        elog "    \"${PN}\": {"
        elog "      \"command\": \"/usr/bin/cortex\","
        elog "      \"args\": [\"mcp\"]"
        elog "    }"
        elog ""
        elog "  Claude Desktop (~/.config/Claude/claude_desktop_config.json):"
        elog "    \"${PN}\": {"
        elog "      \"command\": \"/usr/bin/cortex\","
        elog "      \"args\": [\"mcp\"]"
        elog "    }"
}
