# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 git-r3

DESCRIPTION="Orchestration layer for Gentoo overlay ebuild lifecycle management"
HOMEPAGE="ssh://git@gitlab-ee.thehavennet.org.uk/gentoo/ebuild-updater"
EGIT_REPO_URI="file:///storage/home/haven/projects/ebuild-updater"
EGIT_COMMIT="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="build-test +cron doc mcp notifications qa test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/tomli[${PYTHON_USEDEP}]' python3_10)
	dev-util/nvchecker
	cron? ( virtual/cron )
	notifications? ( dev-python/apprise[${PYTHON_USEDEP}] )
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

	# Install config example
	insinto /etc/${PN}
	newins ebuild-updater.toml.example config.toml.example

	# Always install the hand-written man page
	doman docs/man/ebuild-updater.1

	if use cron; then
		insinto /etc/cron.daily
		newins "${FILESDIR}/ebuild-updater.cron" ebuild-updater
		fperms +x /etc/cron.daily/ebuild-updater
	fi

	if use doc; then
		# Install Sphinx-generated HTML docs
		dodoc -r docs/_build/html

		# Install Sphinx-generated man page alongside the hand-written one
		newman docs/_build/man/ebuild-updater.1 ebuild-updater-api.1
	fi
}

pkg_postinst() {
	elog "ebuild-updater has been installed."
	elog ""
	elog "CONFIGURATION:"
	elog "Please update /etc/ebuild-updater/config.toml based on the example:"
	elog "  /etc/ebuild-updater/config.toml.example"
	elog ""
	elog "CRON:"
	if use cron; then
		elog "A daily cron job has been installed at /etc/cron.daily/ebuild-updater"
		elog "It will only run if /etc/ebuild-updater/config.toml exists."
	else
		elog "Enable the 'cron' USE flag to install a daily update script."
	fi
}
