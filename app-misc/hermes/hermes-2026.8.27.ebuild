# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 systemd

DESCRIPTION="The self-improving AI agent"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"
SRC_URI="https://github.com/NousResearch/hermes-agent/archive/v${PV}.tar.gz -> hermes-agent-${PV}.tar.gz"
S="${WORKDIR}/hermes-agent-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Mapping Extras from pyproject.toml
IUSE="+cli +mcp +web +pty anthropic exa firecrawl parallel-web fal edge-tts modal daytona vercel hindsight messaging slack matrix voice pty honcho homeassistant sms acp bedrock dingtalk feishu google youtube"

RDEPEND="
	dev-python/openai[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/fire[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/socksio[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/tenacity[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/prompt-toolkit[${PYTHON_USEDEP}]
	dev-python/croniter[${PYTHON_USEDEP}]
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	media-video/ffmpeg
	dev-vcs/git
	app-misc/tirith-bin
	
	anthropic? ( dev-python/anthropic[${PYTHON_USEDEP}] )
	exa? ( dev-python/exa-py[${PYTHON_USEDEP}] )
	firecrawl? ( dev-python/firecrawl-py[${PYTHON_USEDEP}] )
	parallel-web? ( dev-python/parallel-web[${PYTHON_USEDEP}] )
	fal? ( dev-python/fal-client[${PYTHON_USEDEP}] )
	edge-tts? ( dev-python/edge-tts[${PYTHON_USEDEP}] )
	modal? ( dev-python/modal[${PYTHON_USEDEP}] )
	daytona? ( dev-python/daytona[${PYTHON_USEDEP}] )
	vercel? ( dev-python/vercel[${PYTHON_USEDEP}] )
	hindsight? ( dev-python/hindsight-client[${PYTHON_USEDEP}] )
	messaging? (
		dev-python/python-telegram-bot[${PYTHON_USEDEP},webhooks]
		dev-python/discord-py[${PYTHON_USEDEP},voice]
		dev-python/aiohttp[${PYTHON_USEDEP}]
		dev-python/brotlicffi[${PYTHON_USEDEP}]
		dev-python/slack-bolt[${PYTHON_USEDEP}]
		dev-python/slack-sdk[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
	)
	slack? (
		dev-python/slack-bolt[${PYTHON_USEDEP}]
		dev-python/slack-sdk[${PYTHON_USEDEP}]
	)
	matrix? (
		dev-python/mautrix[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
		dev-python/aiosqlite[${PYTHON_USEDEP}]
		dev-python/asyncpg[${PYTHON_USEDEP}]
		dev-python/aiohttp-socks[${PYTHON_USEDEP}]
	)
	cli? ( dev-python/simple-term-menu[${PYTHON_USEDEP}] )
	voice? (
		dev-python/faster-whisper[${PYTHON_USEDEP}]
		dev-python/sounddevice[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	pty? ( dev-python/ptyprocess[${PYTHON_USEDEP}] )
	honcho? ( dev-python/honcho-ai[${PYTHON_USEDEP}] )
	mcp? ( dev-python/mcp[${PYTHON_USEDEP}] )
	homeassistant? ( dev-python/aiohttp[${PYTHON_USEDEP}] )
	sms? ( dev-python/aiohttp[${PYTHON_USEDEP}] )
	acp? ( dev-python/agent-client-protocol[${PYTHON_USEDEP}] )
	bedrock? ( dev-python/boto3[${PYTHON_USEDEP}] )
	dingtalk? (
		dev-python/dingtalk-stream[${PYTHON_USEDEP}]
		dev-python/alibabacloud-dingtalk[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
	)
	feishu? (
		dev-python/lark-oapi[${PYTHON_USEDEP}]
		dev-python/qrcode[${PYTHON_USEDEP}]
	)
	google? (
		dev-python/google-api-python-client[${PYTHON_USEDEP}]
		dev-python/google-auth-oauthlib[${PYTHON_USEDEP}]
		dev-python/google-auth-httplib2[${PYTHON_USEDEP}]
	)
	youtube? ( dev-python/youtube-transcript-api[${PYTHON_USEDEP}] )
	web? (
		dev-python/fastapi[${PYTHON_USEDEP}]
		dev-python/uvicorn[${PYTHON_USEDEP}]
		net-libs/nodejs[npm]
	)
"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

# ebuild-side regression test for the hermes_tools/mcp_tool.py
# t.cancel() / closed-loop crash. The upstream tarball ships
# tests/ with 180+ heavy tests that need a running MCP server, a
# hermes config, network access, etc. We only want to run our focused
# guard test, so we override python_test() to copy the ebuild's
# test file and run only it. See files/test_mcp_cancel_guard.py
# for the assertions.
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# 1. Rename all generic top-level modules and directories to be hermes_ prefixed
	local modules=( "cli" "utils" "tools" "agent" "gateway" "tui_gateway" "cron" "plugins" "providers" "acp_adapter" "run_agent" "model_tools" "trajectory_compressor" "batch_runner" )
	for mod in "${modules[@]}"; do
		if [[ -f "${mod}.py" ]]; then
			mv "${mod}.py" "hermes_${mod}.py" || die
		elif [[ -d "${mod}" ]]; then
			mv "${mod}" "hermes_${mod}" || die
		fi
	done

	# We also need to fix the dynamic string in registry.py that was breaking tool discovery
	sed -i 's/f"tools\./f"hermes_tools\./g' hermes_tools/registry.py || die

	# 1.5. Patch hermes_tools/mcp_tool.py: wrap every `t.cancel()` in a
	#      try/except RuntimeError so the python-3.14 stricter Task.cancel
	#      semantics don't raise "Event loop is closed" during shutdown.
	#      Upstream bug is in _wait_for_reconnect_or_shutdown and the keepalive
	#      finally block -- both have the same `if not t.done(): t.cancel()` shape.
	#      Idempotent: sed only matches the unpatched form.
	sed -i -z -E 's|if not t\.done\(\):\n                    t\.cancel\(\)\n|if not t.done():\n                    try:\n                        t.cancel()\n                    except RuntimeError:\n                        # Python 3.14: Task.cancel() raises RuntimeError("Event loop is closed")\n                        # when the loop has already been torn down. The task is unreachable\n                        # so skip the await.\n                        continue\n|g' \
		hermes_tools/mcp_tool.py || die

	# 2. Update imports in all python files.
	# We process file by file to ensure robust boundary matching
	for mod in "${modules[@]}"; do
		find . -name "*.py" -exec sed -i \
			-e "s/\bfrom ${mod}\b/from hermes_${mod}/g" \
			-e "s/\bimport ${mod}\b/import hermes_${mod}/g" \
			{} + || die
		
		# Patch pyproject.toml package list
		sed -i -e "s/\"${mod}\"/\"hermes_${mod}\"/g" \
			-e "s/\"${mod}\./\"hermes_${mod}\./g" \
			pyproject.toml || die
	done

	# 2.5. Fix _ra() in hermes_agent/agent_init.py: the import-rewrite sed
	#      (step 2) only matches `from run_agent` / `import run_agent`, so
	#      _ra()'s bare `return run_agent` is left dangling and NameErrors
	#      on first call. Mirror the rename to the return site.
	#      Class-shaped: matches any version where _ra() returns the
	#      module by its bare (now-renamed) name.
	# Multiple hermes_agent/*.py files have the same _ra() lazy-reference
	# pattern (system_prompt.py, chat_completion_helpers.py,
	# agent_runtime_helpers.py, conversation_loop.py, tool_executor.py,
	# and any future module that adds one). Class-shaped: covers all
	# of them in a single sed. The bare `return run_agent` statement
	# only appears inside these helpers — safe to match across the
	# whole hermes_agent package.
	find "${S}"/hermes_agent -name '*.py' -exec sed -i \
		's/^    return run_agent$/    return hermes_run_agent/' {} + || die

	# 2.6. Patch hermes_cli/plugins.py fake-namespace injection. The
	#      loader's _load_directory_module injects a synthetic
	#      hermes_plugins with __path__=[] into sys.modules whenever
	#      the real namespace package isn't imported yet, which
	#      shadows the real package and breaks sibling plugin
	#      imports (e.g. hermes_plugins.browser.browserbase.provider
	#      from browser_tool.py:168) whenever any user-installed
	#      plugin (e.g. ~/.hermes/plugins/<name>/) triggers discovery
	#      before the real namespace is imported. The patcher imports
	#      the real namespace first (with ImportError fallback).
	#      Class-shaped: idempotent marker check.
	python3 "${FILESDIR}/patch-plugin-loader.py" \
		"${S}/hermes_cli/plugins.py" || die

	# 3. Suppress venv entry point check in doctor.py for Gentoo system-wide install
	if [[ -f hermes_cli/doctor.py ]]; then
		sed -i 's/if sys.platform != "win32":/if False:/' hermes_cli/doctor.py || die
	fi

	# 4. Resolve namespace collision: hermes_cli.py (module file) and
	#    hermes_cli/ (regular package) both exist after renaming.
	#    In Python 3.3+, regular packages take precedence, so
	#    "from hermes_cli import main" resolves to the __init__.py
	#    (which has no 'main'), causing Python to import hermes_cli/main.py
	#    as a MODULE instead of the hermes_cli.py main() function.
	#    Fix: move the module file into the package.
	if [[ -f hermes_cli.py && -d hermes_cli ]]; then
		mv hermes_cli.py hermes_cli/chat_runner.py || die
		cat << 'EOF' >> hermes_cli/__init__.py

def __getattr__(name: str):
    # The upstream monolith cli.py is moved into this package as
    # chat_runner.py (step 4 above), and every `from cli import X` was
    # rewritten to `from hermes_cli import X`. Proxy all names to
    # chat_runner so the monolith's module-level names (ChatConsole,
    # _cprint, logger, AIAgent, CLI_CONFIG, ...) keep resolving at call
    # time — this is how upstream package modules import them.
    # NOTE: importlib.import_module, NOT `import ... as` — the latter
    # binds via getattr() on the parent, which recurses into __getattr__
    # while chat_runner is still mid-import (its module-level
    # load_cli_config() call imports submodules from this package).
    import importlib
    chat_runner = importlib.import_module("hermes_cli.chat_runner")
    try:
        return getattr(chat_runner, name)
    except AttributeError:
        raise AttributeError(f"module {__name__!r} has no attribute {name!r}") from None
EOF
		find . -name "*.py" -exec sed -i \
			-e 's/\bfrom hermes_cli import main\b/from hermes_cli.chat_runner import main/g' \
			{} + || die
	fi

	# 5. Drop the ebuild's regression test into the upstream tests/
	#    tree so the default `epytest` (or our custom `python_test`)
	#    can pick it up. The upstream tests/ dir already exists at
	#    this point and contains conftest.py / fixtures, so we just
	#    add our file alongside. Without USE=test this is a no-op
	#    in terms of runtime cost; the file is still copied in case
	#    a future ebuild drops the python_test override below.
	if [[ -d tests ]]; then
		cp "${FILESDIR}/test_mcp_cancel_guard.py" \
			"tests/test_mcp_cancel_guard.py" || die
	else
		mkdir -p tests || die
		cp "${FILESDIR}/test_mcp_cancel_guard.py" \
			"tests/test_mcp_cancel_guard.py" || die
	fi
}

# Run ONLY the focused regression test, not the full upstream suite.
# The upstream tests/ directory has 180+ tests that require a running
# MCP server, hermes config dir, network access, and a clean HOME.
# This override is what `FEATURES=test emerge app-misc/hermes` will
# execute; everything else in tests/ is intentionally skipped.
python_test() {
	epytest -p no:hydra_pytest tests/test_mcp_cancel_guard.py
}

# Upstream setup.py (2026.8.x) overrides bdist_wheel/sdist to refuse
# wheel builds unless HERMES_NIX_BUILD=1 -- the only supported PEP 517
# path is their Nix derivation. The guard is a pure env-var check that
# then proceeds with a normal wheel build, so exporting it for the
# compile phase is the minimal Gentoo fix. (7.7.2 and earlier had no
# guard; this was introduced upstream between 7.7.2 and 8.3.)
src_compile() {
	HERMES_NIX_BUILD=1 distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	systemd_dounit "${FILESDIR}/hermes-agent.service"
	# Fix hermes-agent entry point: module renamed run_agent -> hermes_run_agent
	sed -i 's/from run_agent import main/from hermes_run_agent import main/' "${ED}"/usr/bin/hermes-agent 2>/dev/null || true
	find "${ED}"/usr/lib/python-exec -name hermes-agent -exec sed -i 's/from run_agent import main/from hermes_run_agent import main/' {} + 2>/dev/null || true
	
	insinto /usr/share/hermes
	doins cli-config.yaml.example
}

pkg_postinst() {
	elog "Hermes Agent has been installed."
	elog "To complete the setup, follow these steps:"
	elog "1. Create a configuration directory: mkdir -p ~/.hermes"
	elog "2. Copy the example config: cp /usr/share/hermes/cli-config.yaml.example ~/.hermes/config.yaml"
	elog "3. Set up your SOUL.md: nano ~/.hermes/SOUL.md"
	elog "4. Run 'hermes setup' to configure providers."
}
