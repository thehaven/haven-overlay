# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )
inherit distutils-r1 pypi

DESCRIPTION="Hermes Agent plugin for RTK terminal output compression"
HOMEPAGE="https://github.com/ogallotti/rtk-hermes"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-misc/rtk"

pkg_postinst() {
	einfo "RTK Hermes plugin installed."
	einfo "Add 'rtk-rewrite' to your ~/.hermes/config.yaml plugins section."
}
