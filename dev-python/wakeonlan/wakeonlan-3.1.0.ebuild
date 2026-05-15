# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1 pypi

DESCRIPTION="A small python module for wake on lan"
HOMEPAGE="https://github.com/remcohaszing/pywakeonlan"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	# Avoid collision with net-misc/wakeonlan
	rm -f "${ED}/usr/bin/wakeonlan" || die
}
