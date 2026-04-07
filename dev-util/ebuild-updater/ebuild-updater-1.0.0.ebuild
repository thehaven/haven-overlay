# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Orchestration layer for Gentoo overlay ebuild lifecycle management"
HOMEPAGE="https://gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater"
SRC_URI="https://gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="build-test doc mcp qa test"
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
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-click[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile_all() {
	if use doc; then
		sphinx-build -b html docs docs/_build/html || die "sphinx HTML build failed"
		sphinx-build -b man docs docs/_build/man || die "sphinx man build failed"
	fi
}

src_install() {
	distutils-r1_src_install

	insinto /usr/share/${PN}
	doins -r templates

	# Always install the hand-written man page
	doman docs/man/ebuild-updater.1

	if use doc; then
		# Install Sphinx-generated HTML docs
		dodoc -r docs/_build/html

		# Install Sphinx-generated man page alongside the hand-written one
		newman docs/_build/man/ebuild-updater.1 ebuild-updater-api.1
	fi
}
