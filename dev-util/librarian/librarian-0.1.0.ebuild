# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_13 )

inherit distutils-r1

DESCRIPTION="Repository catalogue tool"
HOMEPAGE="https://thehavennet.org.uk"
SRC_URI="librarian-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# No production dependencies
RDEPEND="dev-vcs/git"
BDEPEND="dev-python/uv-build[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

RESTRICT="fetch"

S="${WORKDIR}/${PN}"

src_prepare() {
	distutils-r1_src_prepare
	# Patch tests to not use uv run
	sed -i 's/\["uv", "run", "librarian"/\["librarian"/' tests/test_cli.py || die
}

src_test() {
	# Ensure the built script is in PATH
	export PATH="${BUILD_DIR}/install/usr/bin:${PATH}"
	distutils-r1_src_test
}
