# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 git-r3

DESCRIPTION="Repository catalogue tool"
HOMEPAGE="ssh://git@gitlab-ee.thehavennet.org.uk/ai-ml/librarian"
EGIT_REPO_URI="file:///storage/home/haven/projects/services/librarian"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

RDEPEND="dev-vcs/git"
BDEPEND="dev-python/uv-build[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_prepare() {
        distutils-r1_src_prepare
        # Patch tests to not use uv run
        if [[ -f tests/test_cli.py ]]; then
          sed -i 's/\["uv", "run", "librarian"/\["librarian"/' tests/test_cli.py || die
        fi
}

src_test() {
        export PATH="${BUILD_DIR}/install/usr/bin:${PATH}"
        distutils-r1_src_test
}
