# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5..10} )
inherit distutils-r1

DESCRIPTION="A python module dedicated to rendering RST (reStructuredText) documents to ansi-escaped strings suitable for display in a terminal."
HOMEPAGE="https://github.com/Snaipe/python-rst2ansi"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
