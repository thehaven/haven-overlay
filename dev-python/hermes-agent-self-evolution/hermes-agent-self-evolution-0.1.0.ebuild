# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1

DESCRIPTION="Evolutionary self-improvement for Hermes Agent using DSPy + GEPA"
HOMEPAGE="https://github.com/NousResearch/hermes-agent-self-evolution"

# Upstream has no release tags; pinned to the main-branch commit that
# carries version 0.1.0 in pyproject.toml (2026-06-17).
HERMES_EVO_COMMIT="0a929e3aa20e15cf04dc7c28492a7d41a5139125"
SRC_URI="https://github.com/NousResearch/hermes-agent-self-evolution/archive/${HERMES_EVO_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hermes-agent-self-evolution-${HERMES_EVO_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Unit tests are offline (mocked DSPy relevance filter, CliRunner,
# tmp_path fixtures); no live API calls.
distutils_enable_tests pytest

RDEPEND="
	>=dev-python/dspy-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/openai-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0[${PYTHON_USEDEP}]
	>=dev-python/click-8.0[${PYTHON_USEDEP}]
	>=dev-python/rich-13.0[${PYTHON_USEDEP}]
"

pkg_postinst() {
	optfeature "Darwinian Evolver code evolution (upstream darwinian extra; AGPL-3.0)" dev-python/darwinian-evolver
}
