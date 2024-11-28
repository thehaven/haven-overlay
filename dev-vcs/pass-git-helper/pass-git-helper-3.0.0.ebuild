# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..13} )

inherit distutils-r1

DESCRIPTION="Credential helper for Git to retrieve passwords from pass"
HOMEPAGE="https://github.com/languitar/pass-git-helper"
SRC_URI="https://github.com/languitar/pass-git-helper/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pyxdg[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
		app-admin/pass"

src_install() {
	# Install the main script as pass-git-helper
	newbin passgithelper.py pass-git-helper

	# Install documentation
	dodoc README.md
}

