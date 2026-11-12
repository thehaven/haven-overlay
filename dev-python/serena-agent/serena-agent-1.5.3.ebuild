# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="MCP toolkit for coding agents: semantic retrieval, editing, and refactoring"
HOMEPAGE="https://github.com/oraios/serena"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="dashboard"

RDEPEND="
	dev-python/anthropic[${PYTHON_USEDEP}]
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/docstring-parser[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/lsprotocol[${PYTHON_USEDEP}]
	dev-python/mcp[${PYTHON_USEDEP}]
	dev-python/overrides[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/pygls[${PYTHON_USEDEP}]
	dashboard? (
		dev-python/pystray[${PYTHON_USEDEP}]
		dev-python/pywebview[${PYTHON_USEDEP}]
	)
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/python-multipart[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/regex[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/sensai-utils[${PYTHON_USEDEP}]
	dev-python/starlette[${PYTHON_USEDEP}]
	dev-python/tiktoken[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/types-pyyaml[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
"

src_prepare() {
	distutils-r1_src_prepare
	# Upstream has top-level imports of webview that crash when
	# pywebview is not installed (dashboard USE flag disabled).

	# agent.py: move top-level "import webview" into
	# _start_dashboard_viewer_process_function (the only user)
	sed -i '/^import webview$/d' src/serena/agent.py || die
	sed -i '/SerenaDashboardViewer(url, start_minimized/i\            import webview' src/serena/agent.py || die

	# pywebview.py: wrap imports so the module loads without webview
	sed -i 's/^import webview$/try:\n    import webview\n    from PIL import Image\nexcept ImportError:\n    webview = None  # type: ignore\n    Image = None   # type: ignore/' src/serena/util/pywebview.py || die
	sed -i '/^from PIL import Image$/d' src/serena/util/pywebview.py || die
}
