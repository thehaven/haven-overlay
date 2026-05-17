# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 git-r3

DESCRIPTION="Project scaffold and governance engine"
HOMEPAGE="ssh://git@gitlab-ee.thehavennet.org.uk/ai-ml/scaffold-engine"
EGIT_REPO_URI="ssh://git@gitlab-ee.thehavennet.org.uk/ai-ml/scaffold-engine.git"

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/copier[${PYTHON_USEDEP}]
	dev-python/dvc[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/uv-build[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

src_test() {
	export PATH="${BUILD_DIR}/install/usr/bin:${PATH}"
	distutils-r1_src_test
}
