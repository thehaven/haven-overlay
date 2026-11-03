# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( python3_{11..14} )
PYPI_PN="ast-grep-cli"
inherit distutils-r1 pypi

DESCRIPTION="ast-grep-cli Python package"
HOMEPAGE="https://ast-grep.github.io/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="network-sandbox"

RDEPEND=""
BDEPEND="
	dev-util/maturin
	|| ( dev-lang/rust dev-lang/rust-bin )
"

python_install_all() {
	distutils-r1_python_install_all
	# Collides with sys-apps/shadow
	rm -f "${ED}/usr/bin/sg" || die
	# Collides with dev-nodejs/ast-grep-cli
	rm -rf "${ED}/usr/share/doc" || die
}
