# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1

DESCRIPTION="Python client library for the OpenAI API"
HOMEPAGE="https://github.com/openai/openai-python"
SRC_URI="https://github.com/openai/openai-python/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/openai-python-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/anyio[${PYTHON_USEDEP}]
	dev-python/jiter[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	dev-python/distil[${PYTHON_USEDEP}]
	debug? ( dev-python/hermes-observability[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/respx[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	dodoc README.md
}

python_install() {
	if use debug; then
		# Install OpenAI wrapper script for observability
		python_moduleinto "${PN}"
		python_domodule "${FILESDIR}/wrapper.py"
	fi
}

pkg_postinst() {
	if use debug; then
		elog "OpenAI debug mode enabled with LLM observability."
		elog "To enable raw response logging, set:"
		elog "  export HERMES_DEBUG_LLM=1"
		elog "This will log all OpenAI API requests and responses."
		elog "Use with caution in production environments."
	fi
}

