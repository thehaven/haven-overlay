# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit distutils git-2

DESCRIPTION="Low level elasticsearch driver for Python"
HOMEPAGE="https://github.com/humangeo/rawes"
EGIT_REPO_URI="https://github.com/humangeo/rawes.git"

SLOT="0"
LICENSE=""
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
   # Don't install tests.
    rm -Rf "${WORKDIR}/${P}/tests" || return 1
}
