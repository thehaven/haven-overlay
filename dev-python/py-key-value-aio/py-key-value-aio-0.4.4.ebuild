# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_PN="py-key-value-aio"
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="Async Key-Value Store Interface for Python"
HOMEPAGE="https://github.com/thefuzzylogic/py-key-value-aio"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/beartype-0.20.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.15.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	# Patch uv_build to hatchling.build and add hatch-specific config
	sed -i 's/build-backend = "uv_build"/build-backend = "hatchling.build"/' pyproject.toml || die
	cat >> pyproject.toml <<-EOF
		
		[tool.hatch.build.targets.wheel]
		packages = ["key_value"]
	EOF
}
