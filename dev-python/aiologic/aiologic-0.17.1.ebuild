# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )
PYPI_PN="aiologic"

inherit distutils-r1 optfeature pypi

DESCRIPTION="GIL-powered* locking library for Python (asyncio / trio / anyio)"
HOMEPAGE="
	https://github.com/x42005e1f/aiologic
	https://pypi.org/project/aiologic/
"
SRC_URI="https://files.pythonhosted.org/packages/source/a/aiologic/aiologic-${PV}.tar.gz"
S="${WORKDIR}/aiologic-${PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Core runtime deps (sniffio + wrapt) plus optional framework
# integrations (anyio, trio, trio-asyncio) are surfaced via optfeature.
RDEPEND="
	dev-python/sniffio[${PYTHON_USEDEP}]
	>=dev-python/wrapt-1.16.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/typing-extensions-4.10.0[${PYTHON_USEDEP}]' python3_12)
"

BDEPEND="
	dev-python/hatch-vcs
	dev-python/hatchling
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "anyio integration" "dev-python/anyio"
	optfeature "trio integration"  "dev-python/trio"
	optfeature "trio+asyncio bridge" "dev-python/trio-asyncio"
}
