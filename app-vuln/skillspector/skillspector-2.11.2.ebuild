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

# upstream pins typer<0.24 because typer>=0.24 needs click>=8.2.1 which
# conflicts with semgrep's click 8.1.x pin. semgrep is not a dependency
# here and only typer 0.27.x is available, so the upper bound is dropped.
# upstream pins regex==2026.5.9; only date-versioned releases 2026.7.19+
# are packaged. regex keeps a stable API across these, so the exact pin is
# relaxed to the upstream lower bound.
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
"

src_install() {
	distutils-r1_src_install
	# distutils-r1 installs console scripts through python-exec:
	# /usr/bin/skillspector is a symlink to the python-exec2 dispatcher,
	# dangling inside ${ED} (the binary ships with dev-lang/python-exec).
	[[ -L "${ED}/usr/bin/skillspector" ]] || die "console script not installed"
}
