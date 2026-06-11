# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="The self-improving AI agent"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"
SRC_URI="https://github.com/NousResearch/hermes-agent/archive/v2026.5.7.tar.gz -> hermes-agent-${PV}.tar.gz"
S="${WORKDIR}/hermes-agent-2026.5.7"

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

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	distutils-r1_src_prepare

	# Rename modules to avoid namespace collisions (especially with better-brain)
	# Upstream uses way too generic names for top-level site-packages
	mv cli.py hermes_repl.py || die
	mv utils.py hermes_utils.py || die
	mv tools hermes_tools || die

	# Update imports in all python files.
	# We use \b boundary to match exact modules, and also match sub-module imports 
	# e.g., "from tools.registry import" -> "from hermes_tools.registry import"
	find . -name "*.py" -exec sed -i \
		-e 's/\bfrom cli\b/from hermes_repl/g' \
		-e 's/\bimport cli\b/import hermes_repl/g' \
		-e 's/\bfrom utils\b/from hermes_utils/g' \
		-e 's/\bimport utils\b/import hermes_utils/g' \
		-e 's/\bfrom tools\b/from hermes_tools/g' \
		-e 's/\bimport tools\b/import hermes_tools/g' \
		{} + || die

	# Patch pyproject.toml
	sed -i \
		-e 's/"cli"/"hermes_repl"/g' \
		-e 's/"utils"/"hermes_utils"/g' \
		-e 's/"tools"/"hermes_tools"/g' \
		-e 's/"tools\./"hermes_tools\./g' \
		pyproject.toml || die

	# Suppress venv entry point check in doctor.py for Gentoo system-wide install
	if [[ -f hermes_cli/doctor.py ]]; then
		# Replace the "Command Installation" block condition with 'if False:'
		sed -i 's/if sys.platform != "win32":/if False:/' hermes_cli/doctor.py || die
	fi
}

src_install() {
	distutils-r1_src_install
	
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
