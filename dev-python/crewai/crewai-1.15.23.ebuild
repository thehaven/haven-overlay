# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="Cutting-edge framework for orchestrating role-playing, autonomous AI agents"
HOMEPAGE="https://crewai.com https://docs.crewai.com https://github.com/crewAIInc/crewAI"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}")"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Dependencies mirror crewai 1.15.23 pyproject.toml [project].dependencies
# verbatim. crewai-cli and crewai-core are pinned to the exact 1.15.23 release
# to keep the wrapper in lockstep with the sub-packages; bump all three together.
#
# Note: chromadb, lancedb, instructor and cel-python are not in ::gentoo yet.
# They are listed here so `emerge --pretend` surfaces the missing atoms; their
# ebuilds land as separate commits in the same change set.
RDEPEND="
	=dev-python/crewai-cli-1.15.23*
	=dev-python/crewai-core-1.15.23*
	>=dev-python/pydantic-2.11.9[${PYTHON_USEDEP}]
	<dev-python/pydantic-2.13
	>=dev-python/openai-2.30.0[${PYTHON_USEDEP}]
	<dev-python/openai-3
	>=dev-python/instructor-1.3.3[${PYTHON_USEDEP}]
	<dev-python/instructor-1.16
	>=dev-python/pdfplumber-0.11.4[${PYTHON_USEDEP}]
	<dev-python/pdfplumber-0.12
	>=dev-python/regex-2026.1.15[${PYTHON_USEDEP}]
	<dev-python/regex-2027
	>=dev-python/opentelemetry-api-1.42[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-api-2
	>=dev-python/opentelemetry-sdk-1.42[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-sdk-2
	>=dev-python/opentelemetry-exporter-otlp-proto-http-1.42[${PYTHON_USEDEP}]
	<dev-python/opentelemetry-exporter-otlp-proto-http-2
	>=dev-python/chromadb-1.1.0[${PYTHON_USEDEP}]
	<dev-python/chromadb-1.2
	>=dev-python/tokenizers-0.21[${PYTHON_USEDEP}]
	<dev-python/tokenizers-1
	>=dev-python/openpyxl-3.1.5[${PYTHON_USEDEP}]
	<dev-python/openpyxl-3.2
	>=dev-python/python-dotenv-1.2.2[${PYTHON_USEDEP}]
	<dev-python/python-dotenv-2
	>=dev-python/pyjwt-2.13.0[${PYTHON_USEDEP}]
	<dev-python/pyjwt-3
	>=dev-python/click-8.1.7[${PYTHON_USEDEP}]
	<dev-python/click-9
	>=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]
	<dev-python/appdirs-1.5
	>=dev-python/jsonref-1.1.0[${PYTHON_USEDEP}]
	<dev-python/jsonref-1.2
	>=dev-python/json-repair-0.60.1[${PYTHON_USEDEP}]
	<dev-python/json-repair-0.61
	>=dev-python/cel-python-0.5.0[${PYTHON_USEDEP}]
	<dev-python/cel-python-0.6
	>=dev-python/tomli-w-1.1.0[${PYTHON_USEDEP}]
	<dev-python/tomli-w-1.2
	>=dev-python/tomli-2.0.2[${PYTHON_USEDEP}]
	<dev-python/tomli-2.1
	>=dev-python/json5-0.10.0[${PYTHON_USEDEP}]
	<dev-python/json5-0.11
	>=dev-python/portalocker-2.7.0[${PYTHON_USEDEP}]
	<dev-python/portalocker-2.8
	>=dev-python/pydantic-settings-2.14.2[${PYTHON_USEDEP}]
	<dev-python/pydantic-settings-3
	>=dev-python/httpx-0.28.1[${PYTHON_USEDEP}]
	<dev-python/httpx-0.29
	>=dev-python/mcp-1.28.1[${PYTHON_USEDEP}]
	<dev-python/mcp-1.29
	>=dev-python/aiosqlite-0.21.0[${PYTHON_USEDEP}]
	<dev-python/aiosqlite-0.22
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	<dev-python/pyyaml-7
	>=dev-python/aiofiles-24.1.0[${PYTHON_USEDEP}]
	<dev-python/aiofiles-25
	>=dev-python/lancedb-0.29.2[${PYTHON_USEDEP}]
	<dev-python/lancedb-0.30.1
"

# Upstream test suite requires live API access and remote services
RESTRICT="test"

# Upstream pyproject.toml declares `crewai = "crewai_cli.cli:crewai"` under
# [project.scripts]. crewai-cli already installs /usr/bin/crewai; remove
# the wrapper's duplicate to avoid a file-collision at pkg_preinst.
src_install() {
	distutils-r1_src_install
	if [[ -f "${ED}/usr/bin/crewai" ]]; then
		rm "${ED}/usr/bin/crewai" || die
	fi
}

pkg_postinst() {
	optfeature "third-party tool integrations (web scrapers, Notion, Slack, ...)" \
		"=dev-python/crewai-tools-1.15.23*"
}
