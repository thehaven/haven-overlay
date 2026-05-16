# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Patched Playwright — Chromium browser automation (anti-detection fork)"
HOMEPAGE="https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python"
SRC_URI="https://github.com/Kaliiiiiiiiii-Vinyzu/patchright-python/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox test"

IUSE="chromium"

RDEPEND="
	>=dev-python/pyee-13[${PYTHON_USEDEP}]
	>=dev-python/greenlet-3.1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-80.9.0[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

pkg_postinst() {
	elog "patchright is a Playwright fork for Chromium automation."
	elog ""
	elog "Install the Chromium browser:"
	elog "  patchright install chromium"
	elog ""
	elog "Browser binaries cached at ~/.cache/patchright/"
	elog ""
	elog "API is a drop-in replacement for Playwright:"
	elog "  from patchright.sync_api import sync_playwright"
	elog "  from patchright.async_api import async_playwright"
}
