# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="High-level Python API to automate web browsers via Playwright"
HOMEPAGE="
	https://playwright.dev/python/
	https://github.com/microsoft/playwright-python
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Upstream tests require downloading and running browser binaries,
# which cannot run in the network-sandboxed build environment.
RESTRICT="test"

RDEPEND="
	>=dev-python/greenlet-3.1.1[${PYTHON_USEDEP}]
	<dev-python/greenlet-4.0.0[${PYTHON_USEDEP}]
"

BDEPEND="
	>=dev-python/setuptools-82.0.1[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-10.0[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
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
