# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Hermes Agent Context Engine Plugin"
HOMEPAGE="https://github.com/NousResearch/hermes-agent"
SRC_URI="https://github.com/NousResearch/hermes-agent/archive/refs/tags/v${PV}.tar.gz -> hermes-agent-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
S="${WORKDIR}/hermes-agent-${PV}/plugins/."
KEYWORDS="~amd64"

DEPEND=">=app-misc/hermes-2026.5.16"
RDEPEND="${DEPEND}
	dev-python/typer[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/chroma[${PYTHON_USEDEP}]
	dev-python/sentence-transformers[${PYTHON_USEDEP}]
"

PYTHON_COMPAT=( python3_{11..12} )
S="${WORKDIR}/hermes-agent-${PV}/plugins/context_engine"

python_install() {
	distutils-r1_python_install
	python_optimize
}

pkg_postinst() {
	einfo "Hermes Context Engine plugin installed successfully!"
	einfo ""
	einfo "This plugin provides advanced context management and retrieval"
	einfo "capabilities for Hermes Agent using vector embeddings."
	einfo ""
	einfo "Features:"
	einfo "  - Vector-based context storage and retrieval"
	einfo "  - Semantic search capabilities"
	einfo "  - Context persistence and management"
	einfo ""
	einfo "To use the context engine plugin:"
	einfo "1. Ensure ChromaDB is properly configured"
	einfo "2. Start Hermes with context engine enabled"
	einfo "3. Configure context storage settings"
	einfo ""
	einfo "For more information, see the Hermes Agent documentation."
}
