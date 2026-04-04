# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 git-r3

DESCRIPTION="Orchestration layer for Gentoo overlay ebuild lifecycle management"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater"
EGIT_REPO_URI="https://gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="build-test mcp qa test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' python3_10)
	dev-util/nvchecker
	qa? (
		dev-util/pkgcheck
		dev-util/pkgdev
	)
	build-test? ( app-portage/ebuildtester )
	mcp? ( dev-python/mcp[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	insinto /usr/share/${PN}
	doins -r templates
}
