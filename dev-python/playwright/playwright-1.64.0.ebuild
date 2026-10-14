# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

# PyPI does not publish a sdist for this version; use the GitHub source
# tarball. The PyPI metadata.name is "playwright" but the source dir is
# "playwright-python-{version}".
MY_P="playwright-python-${PV}"

inherit distutils-r1

DESCRIPTION="High-level Python API to automate web browsers via Playwright"
HOMEPAGE="
	https://playwright.dev/python/
	https://github.com/microsoft/playwright-python
"
SRC_URI="https://github.com/microsoft/playwright-python/archive/refs/tags/v${PV}.tar.gz
	-> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	<dev-python/pyee-14[${PYTHON_USEDEP}]
	>=dev-python/pyee-13[${PYTHON_USEDEP}]
	>=dev-python/greenlet-3.1.1[${PYTHON_USEDEP}]
	<dev-python/greenlet-4.0.0[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/setuptools-82.0.1
	>=dev-python/setuptools-scm-10.0
	dev-python/wheel
"

# Browser drivers are NOT shipped with this package. After install run
# `playwright install` (or use `playwright install --with-deps` on
# hosts where the user can accept the system-package prompts) to fetch
# the Chromium / Firefox / WebKit binaries.
pkg_postinst() {
	elog "Playwright requires browser drivers which are not bundled."
	elog "Install them with:"
	elog "    ${EPREFIX}/usr/bin/playwright install"
	elog "or with system deps (where supported):"
	elog "    ${EPREFIX}/usr/bin/playwright install --with-deps"
}
